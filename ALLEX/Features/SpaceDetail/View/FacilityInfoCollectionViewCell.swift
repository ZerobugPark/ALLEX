//
//  FacilityInfoCollectionViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

final class FacilityInfoCollectionViewCell: BaseCollectionViewCell {
    
    private let iconView = UIImageView()
    
    private let nameLabel = SubTitleLabel()
    
    override func configureHierarchy() {
        
        contentView.addSubviews(iconView, nameLabel)
        
    }
    
    override func configureLayout() {
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(12)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-12)
        }
        
    }
    
    override func configureView() {
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .red//.setAllexColor(.textSecondary)
        
        nameLabel.font = .setAllexFont(.bold_12)
        
        contentView.backgroundColor = .setAllexColor(.backGroundTertiary)
        contentView.layer.cornerRadius = 8
    }
    
    // MARK: - Configuration
    func configure(with info: FacilityInfo) {
        iconView.image = .setSymbol(from: info.facility)
        nameLabel.text = info.facility
    }
    
}

