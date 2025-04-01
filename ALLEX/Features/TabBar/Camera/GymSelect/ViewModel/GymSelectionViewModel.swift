//
//  GymSelectViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import Foundation

import RxCocoa
import RxSwift



final class GymSelectionViewModel: BaseViewModel {
    
    var sharedData: SharedDataModel
    
    struct Input {
       
    }
    
    struct Output {
        let updateGym: Driver<String>
    }
    
    var disposeBag =  DisposeBag()
    
    
    private let updateGym = PublishRelay<String>()
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        NotificationCenterManager.isSelected.addObserver().bind(with: self) { owner, _ in
            
            
            let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
            
            let info = sharedData.getData(for: String.self)!
            let data = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == info[1] }
     
            
            if languageCode == "en" {
                owner.updateGym.accept(data[0].nameEn)
            } else {
                owner.updateGym.accept(data[0].nameKo)
            }
            
        }.disposed(by: disposeBag)
        
    }
    
    
    func transform(input: Input) -> Output {
    
 
        return Output(updateGym: updateGym.asDriver(onErrorJustReturn: ""))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}
