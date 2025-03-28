//
//  SignUpView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

import SnapKit

final class SignUpView: BaseView {

    let titleLabel = TitleLabel(key: .profileTitle , title: "")
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        titleLabel.font = .setAllexFont(.bold_16)
        titleLabel.textColor = .setAllexColor(.textPirmary)
         
    }
}
