//
//  SignUpView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

import SnapKit

final class SignUpView: BaseView {

    private let titleLabel = TitleLabel(key: .profileTitle , title: "")
    private let circleView = UIView()
    private let nicknameLabel = SubTitleLabel(key: .nicknameTitle, title: "")
    private let dateLabel = SubTitleLabel(key: .startDate, title: "")
    private let spaceLabel = SubTitleLabel(key: .space, title: "")
    
    let nicknameTextField = BaseTextField()
    let infoLabel = TertiaryLabel(key: .verifiedNickName, title: "")
    
    
    let dateTextField = DateTextField()
    
    override func configureHierarchy() {
        self.addSubviews(titleLabel, nicknameLabel, circleView, nicknameTextField, infoLabel, dateLabel, dateTextField, spaceLabel)
        
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(32)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.leading.equalToSuperview().offset(32)
        }
        
        circleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
            make.size.equalTo(6)
        }
    
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
          
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
//        
//        spaceLabel.snp.makeConstraints { make in
//            make.top.equalTo(dateTextField.snp.bottom).offset(25)
//            make.leading.equalToSuperview().offset(32)
//        }
//        

    }
    
    override func configureView() {
        titleLabel.font = .setAllexFont(.bold_24)
        nicknameLabel.font = .setAllexFont(.regular_16)
        dateLabel.font = .setAllexFont(.regular_16)
        spaceLabel.font = .setAllexFont(.regular_16)
            
        infoLabel.textAlignment = .right
        infoLabel.textColor = .setAllexColor(.unvalid)
        infoLabel.font = .setAllexFont(.light_9)
      

        
        circleView.clipsToBounds = true
        circleView.backgroundColor = .setAllexColor(.pirmary)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.bounds.size.width / 2
    }
}
