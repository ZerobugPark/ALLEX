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
        let currentText: ControlProperty<String> //현재 입력된 텍스트
        let signUpTapped: Observable<(ControlProperty<String>.Element, ControlProperty<String>.Element)>
    }
    
    struct Output {
        let nicknameLength: Driver<Int>
        let isNicknameValid: Driver<Bool>
        let showHome: Driver<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    
    
    func transform(input: Input) -> Output {
        
        let nicknameLength =  BehaviorRelay<Int>(value: 0)
        
        let isNicknameValid = BehaviorRelay<Bool>(value: false)
        let showHome = PublishRelay<Void>()
        
        
        input.currentText.bind(with: self) { owner, str in
            nicknameLength.accept(str.count)
            isNicknameValid.accept(owner.isValidNickname(str))
        }.disposed(by: disposeBag)
        
        
        input.signUpTapped.bind(with: self) { owner, value in
            
            UserDefaultManager.isLoggedIn = true
            UserDefaultManager.nickname = value.0
            UserDefaultManager.startDate = value.1.isEmpty ? owner.getCurrentDateString() : value.1
            
            showHome.accept(())
            
        }.disposed(by: disposeBag)
        
        return Output(
            nicknameLength: nicknameLength.asDriver(onErrorRecover: { error in
                print("nicknameLength error: \(error)")
                return Driver.just(0)
            }),
            isNicknameValid: isNicknameValid.asDriver(onErrorRecover: { error in
                print("isNicknameValid error: \(error)")
                return Driver.just(false)
            }),
            showHome: showHome.asDriver(onErrorRecover: { error in
                print("showHome error: \(error)")
                return Driver.just(())
            })
        )
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


// MARK: Logic Function
extension SignUpViewModel {
    
    //만약 유저가 시작 날짜를 등록하지 않을 경우 회원 가입 날짜 등록
    private func getCurrentDateString() -> String {
        return dateFormatter.string(from: Date())
    }
    
    //닉네임 유효성 검사
    private func isValidNickname(_ str: String) -> Bool {
        return str.count > 1 && str.count < 8
    }
}
