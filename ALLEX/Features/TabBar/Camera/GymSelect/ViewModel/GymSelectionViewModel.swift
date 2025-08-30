//
//  GymSelectViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import Foundation

import RxCocoa
import RxSwift
import RealmSwift


final class GymSelectionViewModel: BaseViewModel {
    
    
    struct Input {
        let selectedGym : Driver<[Gym]>
    }
    
    struct Output {
        let recentGym: Driver<[Gym]>
        let updateGym: Driver<String>
        let lableStatus: Driver<Bool>
    }
    
    var disposeBag =  DisposeBag()
    
    
    private let updateGym = PublishRelay<String>()
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    let spaceRepo: any ClimbingSpaceRepository = RealmClimbingSpaceRepository()
    
    var recentGymList: [Gym] = []
    
    
    init() {
        
        NotificationCenterManager.isGymSelected.addObserverVoid().bind(with: self) { owner, _ in
            
            
            let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
            
            let info = UserDefaultManager.selectedClimb
            
            do {
                guard let data = try owner.spaceRepo.fetchGym(gymID: info[1]) else { return }
                
                if languageCode == "en" {
                    owner.updateGym.accept(data.nameEn)
                } else {
                    owner.updateGym.accept(data.nameKo)
                }
                
            } catch {
                print("error")
            }

        }.disposed(by: disposeBag)
        
        
        self.recentGymList = recentVisit()
    }
    
    
    func transform(input: Input) -> Output {
    
        let list = BehaviorRelay(value: recentGymList)
        let status = BehaviorRelay(value: !recentGymList.isEmpty)
        
        
        input.selectedGym.compactMap { $0.first }
            .drive(with: self) { owner, value in
        
            UserDefaultManager.selectedClimb = [value.brandID, value.gymID]
            
            let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
            
            if languageCode == "en" {
                owner.updateGym.accept(value.nameEn)
            } else {
                owner.updateGym.accept(value.nameKo)
            }
        
            
        }.disposed(by: disposeBag)
 
        return Output(recentGym: list.asDriver(onErrorJustReturn: []), updateGym: updateGym.asDriver(onErrorJustReturn: ""), lableStatus: status.asDriver(onErrorJustReturn: false))
    }
    
    deinit {
        print("\(type(of: self)) Deinit")
    }
    
}


extension GymSelectionViewModel {
    
 
    private func recentVisit() -> [Gym] {
        
        // 최근 기록 방문 짐
        let data = repository.findLastBoulderingLists(limit: 10)
        
        var gymSet: Set<Gym> = []
        
        
        guard let gyms = try? spaceRepo.fetchAllGyms() else { return [] }
        for item in data {
            
            let gyms = gyms.filter { $0.gymID == item.gymId }
            gymSet.formUnion(gyms)
        }
        return Array(gymSet)
        
    }
   
}
