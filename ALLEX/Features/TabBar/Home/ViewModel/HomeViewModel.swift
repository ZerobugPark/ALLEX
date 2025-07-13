//
//  HomeViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

import RxCocoa
import RxSwift

import RealmSwift
import WidgetKit




final class HomeViewModel: BaseViewModel {
    
    struct Input {
        let viewdidLoad: Observable<Void>
    }
    
    struct Output {
        let setupUI: Driver<MonthlyClimbingStatistics>
        let setupMonthlyGymList: Driver<MonthlyGymStatistics>
        let stopIndicator: Driver<Void>
        let isChangedName: Driver<(String, String)>
    }
    
    
    var disposeBag = DisposeBag()
    
    private let setupUI = PublishRelay<MonthlyClimbingStatistics>()
    private let setupMonthlyGymList = PublishRelay<MonthlyGymStatistics>()
    
    private let isChangedName = PublishRelay<(String, String)>()
    
    private var sharedData: SharedDataModel
    
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        //기록화면이후 화면 업데이트
        NotificationCenterManager.isUpdatedRecored.addObserverVoid().bind(with: self) { owner, _ in
            
            let data = owner.getUIData()
            owner.setupUI.accept(data)
            
            let monltyData = owner.getMonthlyGymList()
            owner.setupMonthlyGymList.accept(monltyData)
            
        }.disposed(by: disposeBag)
        
        
        //프로필 업데이트
        NotificationCenterManager.isChangedUserInfo.addObserverVoid().bind(with: self) { owner, _ in
            
            let nickname = LocalizedKey.greeting.rawValue.localized(with:  UserDefaultManager.nickname)
            let startDate = DateFormatterHelper.convertStringToDate(UserDefaultManager.startDate)
            let date = LocalizedKey.userId.rawValue.localized(with: (DateFormatterHelper.daysBetween(startDate, Date()) + 1))
            owner.isChangedName.accept((nickname,date))
            
        }.disposed(by: disposeBag)
        
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let stopIndicator = PublishRelay<Void>()
        
        input.viewdidLoad.flatMap {
            NetworkManger.shared.callRequest()
            
        }.observe(on: MainScheduler.instance).bind(with: self) { owner, response in
            
            switch response {
            case .success(let value):
                
                let brand = owner.convertToGyms(from: value[0], type: Brand.self)
                let gyms = owner.convertToGyms(from: value[1], type: Gym.self)
                let gymGrades = owner.convertToGyms(from: value[2], type: GymGrades.self)
                let bouldering = owner.convertToGyms(from: value[3], type: Bouldering.self)
                
                owner.sharedData.updateData(data: brand, for: Brand.self)
                owner.sharedData.updateData(data: gyms, for: Gym.self)
                owner.sharedData.updateData(data: gymGrades, for: GymGrades.self)
                owner.sharedData.updateData(data: bouldering, for: Bouldering.self)
                
                
                /// 월간 기록 및 시도, 시간 등
                let data = owner.getUIData()
                owner.setupUI.accept(data)
                
                /// 최근 가장 많이 방문한 곳
                let monltyData = owner.getMonthlyGymList()
                owner.setupMonthlyGymList.accept(monltyData)
                
                stopIndicator.accept(())
                
            case .failure(let error):
                print(error)
            }
            
            
        }.disposed(by: disposeBag)
        

        
        return Output(
            setupUI: setupUI.asDriver(
                onErrorJustReturn: MonthlyClimbingStatistics()
            ),
            setupMonthlyGymList: setupMonthlyGymList.asDriver(onErrorJustReturn: MonthlyGymStatistics()),
            stopIndicator: stopIndicator.asDriver(onErrorJustReturn: ()),
            isChangedName: isChangedName.asDriver(onErrorJustReturn: (("","")))
        )
    }
    
    deinit {
        print("\(type(of: self)) Deinit")
    }
}


// MARK: Logic Function

extension HomeViewModel {
    
    
    private func getUIData() -> MonthlyClimbingStatistics {
    
        
        
        let data = repository.monthlyBoulderingStatistics()
        UserDefaultManager.latestGrade = data.latestBestGrade
        UserDefaultManager.totalExTime = data.totalTime
        UserDefaultManager.successRate = data.successRate
        
        WidgetCenter.shared.reloadTimelines(ofKind: "AllexWidget")
        
        return data
    }
    
    
    private func getMonthlyGymList() -> MonthlyGymStatistics {
        
        let (totalCount, gymID, visitCount) = repository.monthlyGymListStatistics()
        
        // 총 시도가 0이면 빈 값 반환
        guard totalCount > 0 else {
            return MonthlyGymStatistics(gymName: "", totalCount: 0, mostVisitCount: 0)
        }

        // Gym 리스트에서 해당 gymID에 해당하는 항목 탐색
        guard
            let gymlist = sharedData.getData(for: Gym.self),
            let gym = gymlist.first(where: { $0.gymID == gymID })
        else {
            return MonthlyGymStatistics(gymName: "", totalCount: 0, mostVisitCount: 0)
        }

        return MonthlyGymStatistics(
            gymName: gym.nameKo,
            totalCount: totalCount,
            mostVisitCount: visitCount
        )

        
    }
    
    
   private func convertToGyms<T: Mappable>(from googleSheetData: GoogleSheetData, type: T.Type) -> [T] {
        // 첫 번째 행(헤더)은 제외하고 나머지 데이터를 Gym 객체로 변환
        return googleSheetData.values.dropFirst().map { T(from: $0) }
    }
    
}
