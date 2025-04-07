//
//  SpaceSelectedButton.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//


// MARK: - 장소 상세보기 버튼
import UIKit
import SnapKit

final class SpaceDetialButton: UIButton {

    // 커스텀 이미지 뷰로 버튼의 이미지를 설정
    private let containerView = CustomView(radius: 20, bgColor: .setAllexColor(.backGroundSecondary))
    let title = SubTitleLabel()

    
    init() {
        super.init(frame: .zero)
        
        // customImageView 설정
        addSubview(containerView)
        containerView.addSubview(title)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        
        title.font = .setAllexFont(.bold_16)
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
}
