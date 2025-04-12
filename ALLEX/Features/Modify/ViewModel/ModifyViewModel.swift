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
        let doneButtonTapped: Observable<TimeInterval>
    }
    
    struct Output {
       
        let gymList: Driver<[Gym]>
        let timeTextField: Driver<String>
    }
    
    
    var disposeBag = DisposeBag()
    
    var sharedData: SharedDataModel
    
    
    private var gymList: [Gym] = []

    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
    }
    
    
    
    func transform(input: Input) -> Output {
           
        let outputGymList = BehaviorRelay(value: gymList)
        let userExcersisetime = PublishRelay<String>()
        
        input.spaceTextField.bind(with: self) { owner, _ in
            
            owner.gymList = owner.sharedData.getData(for: Gym.self)!
            
            
            outputGymList.accept(owner.gymList)
            
            
            
        }.disposed(by: disposeBag)
        
        input.doneButtonTapped.bind(with: self) { owner, timeValue in
            
            
            let time = owner.donePressed(time: timeValue)
            userExcersisetime.accept(time)
            
        }.disposed(by: disposeBag)
        
        return Output(gymList: outputGymList.asDriver(onErrorJustReturn: []), timeTextField: userExcersisetime.asDriver(onErrorJustReturn: ""))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension ModifyViewModel {
 
    
    private func donePressed(time: Double) -> String {
        let totalMinutes = Int(time) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        return "\(hours)시간 \(minutes)분"
    }
}
