//
//  ProfileButton.swift
//  ALLEX
//
//  Created by youngkyun park on 4/5/25.
//

import UIKit

import SnapKit

final class ProfileButton: UIButton {
    
    private let containerView = CustomView(radius: 10, bgColor: .setAllexColor(.backGroundSecondary))
    let title = SubTitleLabel()
    let image = UIImageView(image: .setAllexSymbol(.chevronRight))
    
    init() {
        super.init(frame: .zero)
        
        // customImageView 설정
        addSubview(containerView)
        
        containerView.isUserInteractionEnabled = false
        title.isUserInteractionEnabled = false
        image.isUserInteractionEnabled = false
        
        containerView.addSubviews(title, image)
        
        // 버튼이 터치를 제대로 받을 수 있도록 설정
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        
        containerView.addSubviews(title, image)
        // 이미지 뷰의 크기 및 레이아웃 설정
  
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        image.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        image.tintColor = .setAllexColor(.textSecondary)
        title.text = UserDefaultManager.nickname
        title.font = .setAllexFont(.bold_24)
        title.textColor = .setAllexColor(.textPirmary)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
