//
//  CalendarViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

import RxCocoa
import RxSwift

import RealmSwift


struct ClimbingInfo {
    var id: ObjectId = ObjectId()
    var gym: String = ""
    var excersieTime: String = ""
    var climbDate: String = ""
    var totalClimbCount: Int = 0
    var totalSuccessCount: Int = 0
    
}


final class CalendarViewModel: BaseViewModel {
    
    var sharedData: SharedDataModel
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let changedMonth: PublishRelay<(Int,Int)>
        let currentDate: PublishRelay<Date>
    }
    
    struct Output {
        let setupList: Driver<[ClimbingInfo]>
        let eventList: Driver<CalendarList>
    }
    
    struct CalendarList {
        var newYear: Int = 0
        var newMonth: Int = 0
        var list: [String] = []
        
    }
    
    var disposeBag =  DisposeBag()
    
    private let repository: any ClimbingResultRepository = RealmClimbingResultRepository()
    
    private var currentDateList: [ClimbingInfo] = []
    
    // 캐싱을 위한 딕셔너리
    private var gymInfoCache: [String: Gym] = [:]
    
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.cacheGymInfo()
    }

    
    func transform(input: Input) -> Output {
        
        let setupList = BehaviorRelay(value: currentDateList)
        let eventList = BehaviorRelay(value: CalendarList())
        
        // 현재 날짜 데이터 로드 및 캘린더 설정
        let loadCurrentData = { [weak self] (date: Date) in
            guard let self = self else { return }
            
            self.currentDateList = self.formatClimbingData(for: date)
            setupList.accept(self.currentDateList)
        }
        
        // 월 변경 처리
        let handleMonthChange = { [weak self] (year: Int, month: Int) in
            guard let self = self else { return }
            
            let data = self.calendarList(newYear: year, newMonth: month)
            eventList.accept(data)
        }
        
        
        
        input.viewDidLoad.bind(with: self) { owner, _ in
            
            owner.cacheGymInfo()
            
            let date = owner.getCurrentYearAndMonth()
            handleMonthChange(date.year, date.month)
            loadCurrentData(Date())
   
        
        }.disposed(by: disposeBag)
        
        input.changedMonth
            .bind(with: self) { owner, date in
                let (year, month) = date
                handleMonthChange(year, month)
                
            }.disposed(by: disposeBag)
        
        input.currentDate.bind(with: self) { owner, date in
            loadCurrentData(date)
        }.disposed(by: disposeBag)
        
        return Output(setupList: setupList.asDriver(onErrorJustReturn: []), eventList: eventList.asDriver(onErrorJustReturn: CalendarList()))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}


// MARK: Logic Function
extension CalendarViewModel {
    
    
    private func cacheGymInfo() {
        guard let gymList = sharedData.getData(for: Gym.self) else { return }
        for gym in gymList {
            gymInfoCache[gym.gymID] = gym
        }
    }
    
    
    func getCurrentYearAndMonth() -> (year: Int, month: Int) {
        let calendar = Calendar.current
        let date = Date()
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        return (year, month)
    }
    
    func calendarList(newYear: Int, newMonth: Int) -> CalendarList {
        let data = repository.findBoulderingMonthList(in: "\(newYear)-\(newMonth)")
        
        var result = CalendarList()
        
        result.newYear = newYear
        result.newMonth = newMonth
        result.list = data
        
        return result
        
    }
    
    func formatClimbingData(for date: Date) -> [ClimbingInfo] {
        let climbingElements = repository.findBoulderingList(for: date)
        
        if climbingElements.isEmpty {
            return []
        }
        
        return climbingElements.compactMap { climbingElement -> ClimbingInfo?  in
            guard let gym = gymInfoCache[climbingElement.gymId] else {
                return nil
            }

            let (totalClimbCount, totalSuccessCount) = getTotalCounts(from: climbingElement)
            
            return ClimbingInfo(
                id: climbingElement.id,
                gym: Locale.preferredLanguageCode == "en" ? gym.nameEn : gym.nameKo,
                excersieTime: climbingElement.climbTime.toTimeFormat(),
                climbDate: climbingElement.climbDate.toFormattedString(),
                totalClimbCount: totalClimbCount,
                totalSuccessCount: totalSuccessCount
            )
        }
    }

    
    
    private func getTotalCounts(from boulderingList: BoulderingList) -> (totalClimb: Int, totalSuccess: Int) {
        return boulderingList.routeResults
            .filter { $0.totalClimbCount > 0 }  // totalClimbCount가 0이 아닌 것만 필터링
            .reduce((totalClimb: 0, totalSuccess: 0)) { (result, routeResult) in
                return (result.totalClimb + routeResult.totalClimbCount,
                        result.totalSuccess + routeResult.totalSuccessCount)
            }
    }
    
}
