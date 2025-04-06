//
//  SignUpViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import Foundation

import RxCocoa
import RxSwift


final class SignUpViewModel: BaseViewModel {

    

    struct Input {
        let currentText: ControlProperty<String>
        let edited: Observable<ControlProperty<String>.Element>
        let startButtonTapped: Observable<(ControlProperty<String>.Element, ControlProperty<String>.Element)>
    }
    
    struct Output {
        let changedCountLable: Driver<Int>
        let vaildStatus: Driver<Bool>
        let showHome: Driver<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let changedCountLable =  PublishRelay<Int>()
        let vaildStatus = PublishRelay<Bool>()
        let showHome = PublishRelay<Void>()
        
        input.currentText.bind(with: self) { owner, str in
          
            changedCountLable.accept(str.count)
            
        }.disposed(by: disposeBag)
        
        input.edited.bind(with: self) { owner, str in
            vaildStatus.accept(owner.vaildString(str))
            
        }.disposed(by: disposeBag)

        input.startButtonTapped.bind(with: self) { owner, value in
            
            UserDefaultManager.isLoggedIn = true
            UserDefaultManager.nickname = value.0
            
            if value.1.isEmpty {
                UserDefaultManager.startDate = owner.getCurrentDateString()
            } else {
                UserDefaultManager.startDate = value.1
            }
            
            
        
            showHome.accept(())
            
        }.disposed(by: disposeBag)
        
        return Output(changedCountLable: changedCountLable.asDriver(onErrorJustReturn: 0),
                      vaildStatus: vaildStatus.asDriver(onErrorJustReturn: false),
                      showHome: showHome.asDriver(onErrorJustReturn: ()))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension SignUpViewModel {
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }

 
    private func vaildString(_ str: String) -> Bool {
        
        if str.count > 1 && str.count < 8 {
            return true
        } else {
            return false
        }
        
    }
}
