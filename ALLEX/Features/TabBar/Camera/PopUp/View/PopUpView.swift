//
//  PopUpView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class PopUpView: BaseView {
    
    
    private let viewContainer = UIView()

    private let imageView = UIImageView(image: .setAllexSymbol(.list))
    private let writeTitle = SubTitleLabel(key: .writeRecord, title: "")
    private let subWriteTitle = SubTitleLabel(key: .writeRecordSub, title: "")
   
    private let imageView2 = UIImageView(image: .setAllexSymbol(.video))
    private let recodeTitle = SubTitleLabel(key: .videoRecord, title: "")
    private let subRecodeTitle = TertiaryLabel(key: .videoRecordSub, title: "")
    
    private let stackView = UIStackView()
    let writeRecord = UIView()
    let videoRecord = UIView()

    let backButton = BaseButton()


    
    override func configureHierarchy() {
        // 뷰 계층 구조 설정
        self.addSubview(viewContainer)
        
        // backButton (X 버튼) 추가
        viewContainer.addSubviews(backButton, stackView)
    
        // 스택뷰에 둥근 사각형 뷰 추가
        stackView.addArrangedSubviews(writeRecord, videoRecord)
        
        writeRecord.addSubviews(imageView, writeTitle, subWriteTitle)
        videoRecord.addSubviews(imageView2, recodeTitle, subRecodeTitle)
        
        
    }
    
    override func configureLayout() {
        // viewContainer (중앙 뷰) 제약 설정
        viewContainer.snp.makeConstraints { make in
            make.center.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.height.equalTo(self.snp.height).multipliedBy(0.40)
        }
        
        // backButton (X 버튼) 제약 설정
        backButton.snp.makeConstraints { make in
            make.top.equalTo(viewContainer.snp.top).offset(8)
            make.left.equalTo(viewContainer.snp.left).offset(16)
        }
        
        // stackView 제약 설정 (컨테이너 뷰의 인셋 적용)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16) // 왼쪽 인셋 16
        }
        
        // 첫 번째 둥근 사각형 뷰 (roundRectView1) 제약 설정
        writeRecord.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width) // stackView 너비에 맞춤
            make.height.equalTo(viewContainer.snp.height).multipliedBy(0.385) // 원하는 높이 설정
        }
        
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(8)
            make.size.equalTo(16)
        }
        
        writeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(imageView.snp.trailing).offset(6)
        }
        
        subWriteTitle.snp.makeConstraints { make in
            make.top.equalTo(writeTitle.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            
        }
        
        // 두 번째 둥근 사각형 뷰 (roundRectView2) 제약 설정
        videoRecord.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width) // stackView 너비에 맞춤
            make.height.equalTo(viewContainer.snp.height).multipliedBy(0.385)
        }
        
        imageView2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(8)
            make.size.equalTo(16)
        }
        
        recodeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(imageView2.snp.trailing).offset(6)
        }
        
        subRecodeTitle.snp.makeConstraints { make in
            make.top.equalTo(recodeTitle.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            
        }
        
    }
    
    override func configureView() {
        
        // 둥근 사각형 뷰 스타일 설정
        writeRecord.layer.cornerRadius = 20 // 둥근 사각형의 모서리 반지름
        writeRecord.backgroundColor = .setAllexColor(.backGroundTertiary)
        writeRecord.isUserInteractionEnabled = true
        
        videoRecord.layer.cornerRadius = 20 // 둥근 사각형의 모서리 반지름
        videoRecord.backgroundColor = .setAllexColor(.backGroundTertiary)
        videoRecord.isUserInteractionEnabled = true
        
        // 백그라운드가 컬러가 있으면, overCurrentContext기준으로 전체화면
        // clear 일 때는, addSubview한 뷰의 크기 기준
        // clear 할 때는 기본 뷰 자체가 hierarchy에 들어있지 않음
        self.backgroundColor = .setAllexColor(.backGround)
        //스토리보드의 Opacity와 같은 역할
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        viewContainer.layer.cornerRadius = 10
        viewContainer.clipsToBounds = true
        viewContainer.backgroundColor = .setAllexColor(.backGroundSecondary)
        
        // backButton 설정
        backButton.setImage(.setAllexSymbol(.xmark), for: .normal)
        backButton.tintColor = .setAllexColor(.textSecondary)
  
        
        //레이블 설정
        
        writeTitle.font = .setAllexFont(.bold_14)
        subWriteTitle.font = .setAllexFont(.regular_9)
        subWriteTitle.numberOfLines = 3
        
        recodeTitle.font = .setAllexFont(.bold_14)
        subRecodeTitle.font = .setAllexFont(.regular_9)
        subRecodeTitle.numberOfLines = 3
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // 줄 간격을 10으로 설정

        // 텍스트 스타일 적용
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]

        var attributedString = NSAttributedString(string: LocalizedKey.writeRecordSub.rawValue.localized, attributes: attributes)
        subWriteTitle.attributedText = attributedString
        
        attributedString = NSAttributedString(string: LocalizedKey.videoRecordSub.rawValue.localized, attributes: attributes)
        subRecodeTitle.attributedText = attributedString
        
        // 이미지뷰 설정
        imageView.tintColor = .textSecondary
        imageView2.tintColor = .textSecondary
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
    }
    
}
