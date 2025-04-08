//
//  FooterCellCollectionViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

final class FooterCellCollectionViewCell: BaseCollectionViewCell {
    
    
    private let containerView = CustomView(radius: 16, bgColor: .setAllexColor(.backGroundTertiary))
    
    private let iconView = UIImageView()
   
    
    private let messageLabel = TitleLabel()
    
    
    override func configureHierarchy() {
        
        contentView.addSubview(containerView)
        containerView.addSubviews(iconView, messageLabel)
   
    }
    
    override func configureLayout() {

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    
    
    override func configureView() {
        
        iconView.image = UIImage(systemName: "exclamationmark.circle")
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .setAllexColor(.textSecondary)
        
        messageLabel.font = .setAllexFont(.bold_12)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
    }
    
    
    // MARK: - Configuration
    func configure(message: String) {
        messageLabel.text = message
    }
}


