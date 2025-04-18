//
//  SignUpViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

import RxCocoa
import RxSwift



final class SignUpViewController: BaseViewController<SignUpView, SignUpViewModel> {
    
    
    weak var coordinator: SignUpCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.profile.nicknameTextField.delegate = self
    }
    
    override func bind() {
           
        let startButton = mainView.profile.startButton.rx.tap.withLatestFrom(Observable.combineLatest(mainView.profile.nicknameTextField.rx.text.orEmpty, mainView.profile.dateTextField.rx.text.orEmpty))
        
        let input = SignUpViewModel.Input(currentText: mainView.profile.nicknameTextField.rx.text.orEmpty,
                                          signUpTapped: startButton)
        
        let output = viewModel.transform(input: input)
        
        output.nicknameLength.drive(with: self) { owner, length in
            
            owner.verifiedNickName(length: length)
           
        }.disposed(by: disposeBag)
        
        
        
        output.isNicknameValid.drive(with: self) { owner, status in
            
            owner.mainView.profile.startButton.isEnabled = status
            
        }.disposed(by: disposeBag)
        
        output.showHome.drive(with: self) { owner, _ in

            owner.coordinator?.didFinishShighUp()
            
        }.disposed(by: disposeBag)
        
        mainView.profile.dateTextField.rx.controlEvent(.touchDown)
            .bind(with: self) { owner, _ in
                
                owner.mainView.profile.nicknameTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
   
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        coordinator = nil
        print("\(description) Deinit")
    }
    
}

// MARK: ViewModel Setting Func
extension SignUpViewController {
    
    private func verifiedNickName(length: Int) {
        mainView.profile.countLabel.text = "\(length)/7"
        
        if length < 2 {
            
            mainView.profile.infoLabel.text = LocalizedKey.Setting_UnVerified_NickName.rawValue.localized(with: "")
        } else {
            
            mainView.profile.infoLabel.text = LocalizedKey.Setting_Verified_NickName.rawValue.localized(with: "")
        }
        
        mainView.profile.infoLabel.updateTextColorBasedOnLength(count: length)
    }
    
}


// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true // 지우는 경우에는 입력을 허용
        }
        
        if textField.text?.count ?? 0 >= 7 {
            return false  // 더 이상 텍스트를 입력하지 못하게 함
        }
        
        return true
    }
}
