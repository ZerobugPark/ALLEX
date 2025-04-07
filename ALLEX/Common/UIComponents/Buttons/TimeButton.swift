//
//  TimeButton.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import UIKit


final class TimeButton: UIButton {
    
    // 커스텀 이미지 뷰로 버튼의 이미지를 설정
    private let customImageView = UIImageView()
    
    override var isSelected: Bool {
        didSet {
            // isSelected 상태에 따라 이미지를 업데이트
            if isSelected {
                customImageView.image = .setAllexSymbol(.paues)
            } else {
                customImageView.image = .setAllexSymbol(.play)
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        // customImageView 설정
        addSubview(customImageView)
        
        // 이미지 뷰의 크기 및 레이아웃 설정
        customImageView.contentMode = .scaleAspectFit
        customImageView.tintColor = .setAllexColor(.textTertiary) // 이미지 색상
        
        // 초기 이미지 설정
        customImageView.image = .setAllexSymbol(.paues)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 레이아웃 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // customImageView의 크기와 위치를 설정
        customImageView.frame = bounds // 버튼의 전체 크기를 이미지 뷰의 크기로 설정
    }
}
