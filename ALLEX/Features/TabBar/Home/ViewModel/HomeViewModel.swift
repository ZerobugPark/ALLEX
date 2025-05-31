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
        let stopIndicator: Driver<Void>
        let isChangedName: Driver<(String, String)>
    }
    
    
    var disposeBag = DisposeBag()
    
    private let setupUI = PublishRelay<MonthlyClimbingStatistics>()
    private let isChangedName = PublishRelay<(String, String)>()
    
    private var sharedData: SharedDataModel
    
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        //기록화면이후 화면 업데이트
        NotificationCenterManager.isUpdatedRecored.addObserverVoid().bind(with: self) { owner, _ in
            
            let data = owner.getUIData()
            owner.setupUI.accept(data)
            
        }.disposed(by: disposeBag)
        
        
        //프로필 업데이트
        NotificationCenterManager.isChangedUserInfo.addObserverVoid().bind(with: self) { owner, _ in
            
            let name = UserDefaultManager.nickname
            let startDate = DateFormatterHelper.convertStringToDate(UserDefaultManager.startDate)
            let date = LocalizedKey.userId.rawValue.localized(with: (DateFormatterHelper.daysBetween(startDate, Date()) + 1))
            owner.isChangedName.accept((name,date))
            
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
                
                let data = owner.getUIData()
                
                owner.setupUI.accept(data)
                stopIndicator.accept(())
                
            case .failure(let error):
                print(error)
            }
            
            
        }.disposed(by: disposeBag)
        

        
        return Output(setupUI: setupUI.asDriver(onErrorJustReturn: MonthlyClimbingStatistics()), stopIndicator: stopIndicator.asDriver(onErrorJustReturn: ()), isChangedName: isChangedName.asDriver(onErrorJustReturn: (("",""))))
    }
    
    deinit {
        print("\(type(of: self)) Deinit")
    }
}


// MARK: Logic Function

extension HomeViewModel {
    
    
    func getUIData() -> MonthlyClimbingStatistics {
    
        let data = repository.statistics()
        print(data.nickName)
        print("2233", UserDefaultManager.nickname)
        UserDefaultManager.latestGrade = data.latestBestGrade
        UserDefaultManager.totalExTime = data.totalTime
        UserDefaultManager.successRate = data.successRate
        
        WidgetCenter.shared.reloadTimelines(ofKind: "AllexWidget")
        
        return data
    }
    
    func convertToGyms<T: Mappable>(from googleSheetData: GoogleSheetData, type: T.Type) -> [T] {
        // 첫 번째 행(헤더)은 제외하고 나머지 데이터를 Gym 객체로 변환
        return googleSheetData.values.dropFirst().map { T(from: $0) }
    }
    
}
