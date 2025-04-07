//
//  ProfileViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/5/25.
//

import Foundation

import RxSwift
import RxCocoa


final class ProfileViewModel: BaseViewModel {
    
    struct Input {
    
    }
    
    struct Output {
        let isChangedName: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    private var sharedData: SharedDataModel
  
    
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        
    }

    
    
    func transform(input: Input) -> Output {
        
        let isChangedName = PublishRelay<String>()
        
        NotificationCenterManager.isChangedUserInfo.addObserverVoid().bind(with: self) { owner, _ in
            
            let name = UserDefaultManager.nickname
            
            isChangedName.accept(name)
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(isChangedName: isChangedName.asDriver(onErrorJustReturn: ""))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension ProfileViewModel
{
    
    
}
