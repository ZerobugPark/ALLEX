//
//  ProfileSettingViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/5/25.
//

import UIKit

import RxSwift
import RxCocoa

final class ProfileSettingViewController: BaseViewController<SignUpView, SignUpViewModel> {
    
    weak var coordinator: ProfileCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainView.profile.nicknameTextField.delegate = self
    }
    
    override func bind() {
        
        let edited = mainView.profile.nicknameTextField.rx.controlEvent(.editingDidEnd).withLatestFrom(mainView.profile.nicknameTextField.rx.text.orEmpty)
        
        let startButton = mainView.profile.startButton.rx.tap.withLatestFrom(Observable.combineLatest(mainView.profile.nicknameTextField.rx.text.orEmpty, mainView.profile.dateTextField.rx.text.orEmpty))
        
        let input = SignUpViewModel.Input(currentText: mainView.profile.nicknameTextField.rx.text.orEmpty,
                                          edited: edited,
                                          startButtonTapped: startButton)
        
        let output = viewModel.transform(input: input)
        
        output.changedCountLable.drive(with: self) { owner, value in
            
            owner.mainView.profile.countLabel.text = "\(value)/7"
            
            if value < 2 {
                
                owner.mainView.profile.infoLabel.text = LocalizedKey.unVerifiedNickName.rawValue.localized(with: "")
            } else {
                
                owner.mainView.profile.infoLabel.text = LocalizedKey.verifiedNickName.rawValue.localized(with: "")
            }
            owner.mainView.profile.infoLabel.updateTextColorBasedOnLength(count: value)
        }.disposed(by: disposeBag)
        
        
        
        output.vaildStatus.drive(with: self) { owner, status in
            
            owner.mainView.profile.startButton.isEnabled = status
            
        }.disposed(by: disposeBag)
        
        output.showHome.drive(with: self) { owner, _ in

            NotificationCenterManager.isChangedUserInfo.post()
            owner.coordinator?.popView()
        }.disposed(by: disposeBag)
        
        mainView.profile.dateTextField.rx.controlEvent(.touchDown)
            .bind(with: self) { owner, _ in
                
                owner.mainView.profile.nicknameTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

// MARK: - UITextFieldDelegate
extension ProfileSettingViewController: UITextFieldDelegate {
    
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
