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
    
    private let setupUI = BehaviorSubject(value: MonthlyClimbingStatistics()) //<MonthlyClimbingStatistics>()
    private let setupMonthlyGymList = BehaviorSubject(value: MonthlyGymStatistics())
    
    private let isChangedName = PublishRelay<(String, String)>()
    
    private var sharedData: SharedDataModel
    
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    let spaceRepo: any ClimbingSpaceRepository = RealmClimbingSpaceRepository()
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        //기록화면이후 화면 업데이트
        NotificationCenterManager.isUpdatedRecored.addObserverVoid().bind(with: self) { owner, _ in
            
            let data = owner.getUIData()
            owner.setupUI.onNext(data)
            //owner.setupUI.accept(data)
            
            let monltyData = owner.getMonthlyGymList()
            owner.setupMonthlyGymList.onNext(monltyData)
            
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
        
        
        
        input.viewdidLoad.bind(with: self) { owner, response in
            /// 월간 기록 및 시도, 시간 등
            let data = owner.getUIData()
            owner.setupUI.onNext(data)
            //owner.setupUI.accept(data)
            
            /// 최근 가장 많이 방문한 곳
            let monltyData = owner.getMonthlyGymList()
            owner.setupMonthlyGymList.onNext(monltyData)
                
            
        }.disposed(by: disposeBag)
        
        
//        input.viewdidLoad.flatMap {
//            NetworkManger.shared.fetchRemoteDBVersion()
//
//        }.observe(on: MainScheduler.instance).bind(with: self) { owner, response in
//
//            switch response {
//            case .success(let value):
//                
//                let versions: [DatabaseVersion] = owner.convertToGyms(from: value, type: DatabaseVersion.self)
//                let remoteVersion = versions.first?.version ?? ""
//                let localDBVersion = UserDefaultManager.databaseVersion
//                if remoteVersion == localDBVersion {
//                    owner.loadRealmRepository()
//                } else {
//                    Task {
//                        await owner.refreshAllDataFromGoogleDB(remoteVersion: remoteVersion)
//                    }
//                }
//
//                /// 월간 기록 및 시도, 시간 등
//                let data = owner.getUIData()
//                owner.setupUI.accept(data)
//                
//                /// 최근 가장 많이 방문한 곳
//                let monltyData = owner.getMonthlyGymList()
//                owner.setupMonthlyGymList.accept(monltyData)
//                
//                
//                
//            case .failure(let error):
//                print(error)
//            }
//            
//            
//        }.disposed(by: disposeBag)
//        
        
        
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
            return MonthlyGymStatistics()
        }
        
        do {
            let gymlist = try spaceRepo.fetchAllGyms()
            print(gymlist)
            guard let gym = gymlist.first(where: { $0.gymID == gymID }) else {
                return MonthlyGymStatistics()
            }

            return MonthlyGymStatistics(
                gymName: gym.nameKo,
                totalCount: totalCount,
                mostVisitCount: visitCount
            )
        } catch {
            // Realm fetch 실패했을 때
            return MonthlyGymStatistics()
        }
        
        
        
    }
    
    private func convertToGyms<T: Mappable>(from googleSheetData: GoogleSheetData, type: T.Type) -> [T] {
        // 첫 번째 행(헤더)은 제외하고 나머지 데이터를 Gym 객체로 변환
        return googleSheetData.values.dropFirst().map { T(from: $0) }
    }
    
    
}


private extension HomeViewModel {
    
    func loadRealmRepository() {
        
        do {
            let brands = try spaceRepo.fetchBrands()
            let gyms = try spaceRepo.fetchAllGyms()
            let gymGrades = try spaceRepo.fetchGymGrades()
            let bouldering = try spaceRepo.fetchBouldering()
            
            syncBoulderingData(brands: brands, gyms: gyms, gymGrades: gymGrades, bouldering: bouldering)
            
        } catch {
            print("Realm fetch 실패:", error)
        }

    }
    
    func refreshAllDataFromGoogleDB(remoteVersion: String) async {
        
        let result = await NetworkManger.shared.callRequest()
        
        switch result {
        case .success(let value):
            let brands = convertToGyms(from: value[0], type: Brand.self)
            let gyms = convertToGyms(from: value[1], type: Gym.self)
            let gymGrades = convertToGyms(from: value[2], type: GymGrades.self)
            let bouldering = convertToGyms(from: value[3], type: Bouldering.self)
            
            do {
                try spaceRepo.upsertAll(brands: brands, gyms: gyms, grades: gymGrades, boulders: bouldering)
            } catch {
                print("렘 저장 오류",error)
            }
            
            syncBoulderingData(brands: brands, gyms: gyms, gymGrades: gymGrades, bouldering: bouldering)
            
            UserDefaultManager.databaseVersion = remoteVersion

        case .failure(let failure):
            print("error", failure)
            
        }
        
        
    }
    
    func syncBoulderingData(brands: [Brand], gyms: [Gym], gymGrades: [GymGrades], bouldering: [Bouldering]) {
        
        sharedData.updateData(data: brands, for: Brand.self)
        sharedData.updateData(data: gyms, for: Gym.self)
        sharedData.updateData(data: gymGrades, for: GymGrades.self)
        sharedData.updateData(data: bouldering, for: Bouldering.self)
    }
    
}
