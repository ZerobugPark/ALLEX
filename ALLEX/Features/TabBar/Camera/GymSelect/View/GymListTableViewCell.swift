//
//  GymListTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import SnapKit

final class GymListTableViewCell: BaseTableViewCell {

    private let title = SubTitleLabel()
    private let subTitle = TertiaryLabel()


    override func configureHierarchy() {
        contentView.addSubviews(title, subTitle)

    }
    
    override func configureLayout() {
    
        
        title.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(-16)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            

        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
    }
    
    override func configureView() {
        title.font = .setAllexFont(.bold_14)
        subTitle.font = .setAllexFont(.regular_12)
        subTitle.lineBreakMode = .byTruncatingTail
        subTitle.numberOfLines = 2
           
        
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

  
    }
    
    
}
