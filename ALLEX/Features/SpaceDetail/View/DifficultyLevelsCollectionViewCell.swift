//
//  DifficultyLevelsCollectionViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

final class DifficultyLevelsCollectionViewCell: BaseCollectionViewCell {
    
    private let circleView =  UIView()
        
       
    private let gradeLabel = SubTitleLabel()
           
      
       override func configureHierarchy() {
           contentView.addSubviews(circleView,gradeLabel)
    
       }
       
       override func configureLayout() {
           circleView.snp.makeConstraints { make in
               make.center.equalToSuperview()
               make.width.height.equalTo(36) // Fixed size for circle
           }
           
           gradeLabel.snp.makeConstraints { make in
               make.center.equalTo(circleView) // Center label in circle
           }
           
     
       }
       
       override func configureView() {
           circleView.layer.cornerRadius = 18 // Half of the width/height
           circleView.clipsToBounds = true
           
           gradeLabel.font = .setAllexFont(.bold_12)
           
           contentView.backgroundColor = .none
       }
       
       func configure(with difficultyLevel: BoulderingGrade) {
           circleView.backgroundColor = .setBoulderColor(from: difficultyLevel.color)
           gradeLabel.text = difficultyLevel.difficulty
           
    
       }
    
 
}


