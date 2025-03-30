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
        mainView.nicknameTextField.delegate = self
    }
    
    override func bind() {
        
        let edited = mainView.nicknameTextField.rx.controlEvent(.editingDidEnd).withLatestFrom(mainView.nicknameTextField.rx.text.orEmpty)
        
        let startButton = mainView.startButton.rx.tap.withLatestFrom(Observable.combineLatest(mainView.nicknameTextField.rx.text.orEmpty, mainView.dateTextField.rx.text.orEmpty))
        
        let input = SignUpViewModel.Input(currentText: mainView.nicknameTextField.rx.text.orEmpty,
                                          edited: edited,
                                          startButtonTapped: startButton)
        
        let output = viewModel.transform(input: input)
        
        output.changedCountLable.drive(with: self) { owner, value in
            
            owner.mainView.countLabel.text = "\(value)/7"
            
            if value < 2 {
                
                owner.mainView.infoLabel.text = LocalizedKey.unVerifiedNickName.rawValue.localized(with: "")
            } else {
                
                owner.mainView.infoLabel.text = LocalizedKey.verifiedNickName.rawValue.localized(with: "")
            }
            owner.mainView.infoLabel.updateTextColorBasedOnLength(count: value)
        }.disposed(by: disposeBag)
        
        
        
        output.vaildStatus.drive(with: self) { owner, status in
            
            owner.mainView.startButton.isEnabled = status
            
        }.disposed(by: disposeBag)
        
        output.showHome.drive(with: self) { owner, _ in

            owner.coordinator?.didFinishShighUp()
            
        }.disposed(by: disposeBag)
        
        mainView.dateTextField.rx.controlEvent(.touchDown)
            .bind(with: self) { owner, _ in
                
                owner.mainView.nicknameTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
   
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
