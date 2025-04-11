//
//  ModifyViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/10/25.
//

import Foundation

import RxCocoa
import RxSwift


final class ModifyViewModel: BaseViewModel {
    
    struct Input {
        let spaceTextField: ControlProperty<String>
    }
    
    struct Output {
       
        let gymList: Driver<[Gym]>
    }
    
    
    var disposeBag = DisposeBag()
    
    var sharedData: SharedDataModel
    
    
    private var gymList: [Gym] = []

    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
    }
    
    
    
    func transform(input: Input) -> Output {
           
        let outputGymList = BehaviorRelay(value: gymList)
        
        input.spaceTextField.bind(with: self) { owner, _ in
            
            owner.gymList = owner.sharedData.getData(for: Gym.self)!
            
            
            outputGymList.accept(owner.gymList)
            
            
            
        }.disposed(by: disposeBag)
        
        return Output(gymList: outputGymList.asDriver(onErrorJustReturn: []))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension ModifyViewModel {
    
}
