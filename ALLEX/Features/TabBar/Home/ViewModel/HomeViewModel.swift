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
        let setupUI: Driver<HomeData>
        let stopIndicator: Driver<Void>
        let isChangedName: Driver<(String, String)>
    }
    
    
    struct HomeData {
        let nickName: String
        let date: String
        let tryCount: String
        let successCount: String
        let successRate: String
        let totalTime: String
        let latestBestGrade: String // 마지막 기록 중 최고 기록
        
    }
    
    var disposeBag = DisposeBag()
    
    private let setupUI = PublishRelay<HomeData>()
    private let isChangedName = PublishRelay<(String, String)>()
    
    private var sharedData: SharedDataModel
    
    let repository: any MonthlyClimbingStatisticsRepository = RealmMonthlyClimbingStatisticsRepository()
    
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
            let startDate = owner.convertStringToDate(UserDefaultManager.startDate)
            let date = LocalizedKey.userId.rawValue.localized(with: (owner.daysBetween(startDate, Date()) + 1))
            owner.isChangedName.accept((name,date))
            
        }.disposed(by: disposeBag)
        
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let stopIndicator = PublishRelay<Void>()
        
        let emptyData = HomeData(nickName: "", date: "", tryCount: "", successCount: "", successRate: "", totalTime: "", latestBestGrade: "")
        
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
        

        
        return Output(setupUI: setupUI.asDriver(onErrorJustReturn: emptyData), stopIndicator: stopIndicator.asDriver(onErrorJustReturn: ()), isChangedName: isChangedName.asDriver(onErrorJustReturn: (("",""))))
    }
    
    deinit {
        print("\(type(of: self)) Deinit")
    }
}


// MARK: Logic Function

extension HomeViewModel {
    
    
    func getUIData() -> HomeData {
        
        let data = repository.getCurrentMonthStatistics()
        
        let startDate = convertStringToDate(UserDefaultManager.startDate)
        let date = LocalizedKey.userId.rawValue.localized(with: (daysBetween(startDate, Date()) + 1))
        let nickname = LocalizedKey.greeting.rawValue.localized(with:  UserDefaultManager.nickname)
        
        let totalMonthTime = (data?.totalClimbTime ?? 0).toTimeFormat()
        let latestGrade = data?.lastGrade ?? ""
        let successRate = String(format: "%.0f%%", data?.sucessRate ?? 0)
        
        
        UserDefaultManager.latestGrade = latestGrade
        UserDefaultManager.totalExTime = totalMonthTime
        UserDefaultManager.successRate = successRate
        WidgetCenter.shared.reloadTimelines(ofKind: "AllexWidget")
        
        return HomeData(nickName: nickname, date: date, tryCount: "\(data?.totalClimbCount ?? 0)", successCount: "\(data?.totalSuccessCount ?? 0)", successRate: successRate, totalTime: totalMonthTime, latestBestGrade: latestGrade)
    }
    
    func convertToGyms<T: Mappable>(from googleSheetData: GoogleSheetData, type: T.Type) -> [T] {
        // 첫 번째 행(헤더)은 제외하고 나머지 데이터를 Gym 객체로 변환
        return googleSheetData.values.dropFirst().map { T(from: $0) }
    }
    
    func convertStringToDate(_ dateString: String) -> Date? {
        let formats = [
            "yyyy-MM-dd", // 2025-04-06 형식
            "MMM d, yyyy",// Apr 6, 2025 형식
            "yyyy. M. d." // 2025. 4. 6
        ]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                //print(date)
                return date
            }
        }
        
        return nil
    }
    
    func daysBetween(_ startDate: Date?, _ endDate: Date) -> Int {
        
        guard let startDate = startDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    

    
}
