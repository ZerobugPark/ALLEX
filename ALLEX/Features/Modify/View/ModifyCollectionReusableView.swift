//
//  ModifyCollectionReusableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/13/25.
//

import UIKit

import SnapKit

class ModifyCollectionReusableView: UICollectionReusableView {
    // MARK: - Properties
    private let leftLabel = SubTitleLabel(title: "난이도")
    private let centerLabel = SubTitleLabel(title: "시도")
    private let rightLabel = SubTitleLabel(title: "성공")
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 공통 레이블 설정
        [leftLabel, centerLabel, rightLabel].forEach { label in
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            addSubview(label)
        }
        
        // 2:4:4 비율로 레이아웃 설정 (총합 10)
        leftLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2) // 2/10 비율
        }
        
        centerLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4) // 4/10 비율
        }
        
        rightLabel.snp.makeConstraints { make in
            make.leading.equalTo(centerLabel.snp.trailing)
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4) // 4/10 비율
        }
        
    }
    
}
