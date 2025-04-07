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
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
    }
    
    
    func transform(input: Input) -> Output {
        
        let setupList = BehaviorRelay(value: currentDateList)
        let eventList = BehaviorRelay(value: CalendarList())
       
        input.viewDidLoad.bind(with: self) { owner, _ in
            
            
            owner.currentDateList = owner.formatData(for: Date())
            
            let date = owner.getCurrentYearAndMonth()
            let data = owner.calendarList(newYear: date.year, newMonth: date.month)
            
            eventList.accept(data)
            setupList.accept(owner.currentDateList)
            
            
        }.disposed(by: disposeBag)
        
        input.changedMonth.bind(with: self) { owner, value in
            
            let data = owner.calendarList(newYear: value.0, newMonth: value.1)
            eventList.accept(data)
            
        }.disposed(by: disposeBag)
        
        input.currentDate.bind(with: self) { owner, date in
            
            owner.currentDateList = owner.formatData(for: date)
            setupList.accept(owner.currentDateList)
        }.disposed(by: disposeBag)
        
        return Output(setupList: setupList.asDriver(onErrorJustReturn: []), eventList: eventList.asDriver(onErrorJustReturn: CalendarList()))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}

extension CalendarViewModel {
    
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
    
    func formatData(for date: Date) -> [ClimbingInfo] {
        
        let data = repository.findBoulderingList(for: date)
        
        var resultData: [ClimbingInfo]  = []
        
        
        if data.isEmpty {
            return []
        }
        
        
        for element in data {
            
            var result = ClimbingInfo()
            
            let gymInfo = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == element.gymId }
            
            
            let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
            
            if languageCode == "en" {
                result.gym = gymInfo[0].nameEn
            } else {
                result.gym = gymInfo[0].nameKo
            }
            
            
            result.climbDate = convertToDataFormat(element.climbDate)
            result.excersieTime = convertToTimeFormat(element.climbTime)

            
            let (totalClimbCount, totalSuccessCount) = getTotalCounts(from: element)
            result.totalClimbCount = totalClimbCount
            result.totalSuccessCount = totalSuccessCount
            result.id = element.id
            resultData.append(result)
        }
        
      

        return resultData
    }
    
    private func convertToDataFormat(_ date: Date) -> String {
        
        
        let dateFormatter = DateFormatter()
        
        // 현재 로케일 및 시간대에 맞게 설정
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        // 원하는 포맷 설정 (yyyy-MM-dd <HH:mm> EEEE -> 요일 포함)
        dateFormatter.dateFormat = "yyyy-MM-dd EEEE"
        
        // Date를 원하는 포맷으로 변환
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    
    private func convertToTimeFormat(_ time: Int) -> String {
        
        // 시와 분으로 변환
        let hours = time / 60
        let minutes = time % 60
        
        // 두 자릿수로 포맷팅
        return String(format: "%02d:%02d", hours, minutes)
        
        
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
