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
    
    var sharedData: SharedDataModel
    
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
    
    var recentGymList: [Gym] = []
    
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        NotificationCenterManager.isGymSelected.addObserverVoid().bind(with: self) { owner, _ in
            
            
            let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
            
            let info = sharedData.getData(for: String.self)!
            let data = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == info[1] }
     
            
            if languageCode == "en" {
                owner.updateGym.accept(data[0].nameEn)
            } else {
                owner.updateGym.accept(data[0].nameKo)
            }
            
        }.disposed(by: disposeBag)
        
        
        //self.recentGymList = recentVisit()
    }
    
    
    func transform(input: Input) -> Output {
    
        let list = BehaviorRelay(value: recentGymList)
        let status = BehaviorRelay(value: !recentGymList.isEmpty)
        
        
        input.selectedGym.compactMap { $0.first }
            .drive(with: self) { owner, value in
            owner.sharedData.updateData(data: [value.brandID, value.gymID], for: String.self)
            
            
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
    
//    private func recentVisit() -> [Gym] {
//        
//        // 최근 기록 방문 짐
//        let data = repository.findLastBoulderingLists(limit: 10)
//        
//        var gymSet: Set<Gym> = []
//        
//        for item in data {
//            let gyms = sharedData.getData(for: Gym.self)!.filter { $0.gymID == item.gymId }
//            gymSet.formUnion(gyms)
//        }
//        
//        return Array(gymSet)
//    }
   
}
