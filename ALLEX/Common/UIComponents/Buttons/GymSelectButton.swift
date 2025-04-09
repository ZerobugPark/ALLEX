//
//  GymSelectButton.swift
//  ALLEX
//
//  Created by youngkyun park on 4/9/25.
//

import UIKit

final class GymSelectButton: UIButton {
    
    // 커스텀 이미지 뷰로 버튼의 이미지를 설정
    private let customImageView = UIImageView(image: UIImage(resource: .carabiner))
    let nameLabel = TitleLabel()

    init() {
        super.init(frame: .zero)
        
    
        // customImageView 설정
        self.addSubviews(customImageView, nameLabel)
        
        
        customImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(nameLabel.snp.leading).offset(-8)
            make.size.equalTo(24)
        }

        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(4)
        }
        
    
        
        // 이미지 뷰의 크기 및 레이아웃 설정
        customImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .setAllexFont(.bold_16)
        nameLabel.text = "클라이밍장을 선택해주세요."
        

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
