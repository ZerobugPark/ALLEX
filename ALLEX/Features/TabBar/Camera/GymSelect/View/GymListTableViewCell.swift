//
//  GymListTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymListTableViewCell: BaseTableViewCell {


    private let gymImage = UIImageView(image: .setAllexSymbol(.starFill))
    private let title = SubTitleLabel()
    private let subTitle = TertiaryLabel()
    private let likeButton = UIImageView(image: .setAllexSymbol(.star))

    

    override func configureHierarchy() {
        contentView.addSubviews(gymImage, title, subTitle, likeButton)
    }
    
    override func configureLayout() {
    
        gymImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(contentView.snp.height).multipliedBy(0.5)
            
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(-16)
            make.leading.equalTo(gymImage.snp.trailing).offset(24)
            make.trailing.equalTo(likeButton.snp.leading).offset(-32)

        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalTo(gymImage.snp.trailing).offset(24)
            make.trailing.equalTo(likeButton.snp.leading).offset(-32)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(contentView.snp.height).multipliedBy(0.3)
            
        }
        
        
    
        
    }
    
    override func configureView() {
        title.font = .setAllexFont(.bold_14)
        subTitle.font = .setAllexFont(.regular_12)
        subTitle.lineBreakMode = .byTruncatingTail
        subTitle.numberOfLines = 2
           
        likeButton.tintColor = .pirmary
        contentView.backgroundColor = .backGroundSecondary
        
    }
    
    func setupUI(data: Gym) {
        let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
        
        
        if languageCode == "en" {
            title.text = data.nameEn
            subTitle.text = data.addressEn
            subTitle.setLineSpacing(4)
        } else {
            title.text = data.nameKo
            subTitle.text = data.addressKo
            subTitle.setLineSpacing(4)
        }
    
        Task {
            do {
                let data = try await NetworkManger.shared.fetchAsycnAwait(url: data.imageURL)
                gymImage.image = data
            } catch {
                gymImage.image = .setAllexSymbol(.star)
            }
            
        }
        
        
        
    }
    
    
}
