//
//  VideoGradeCell.swift
//  ALLEX
//
//  Created by youngkyun park on 8/30/25.
//

import Foundation


final class VideoGradeCell: BaseCollectionViewCell {
    
    
    private let colorIndicator = CustomView()
    
    
    override func configureHierarchy() {
        contentView.addSubview(colorIndicator)

    }
    
    override func configureLayout() {
        // 2. Color indicator constraints
        colorIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
    }
    
    override func configureView() {
        // Color indicator
        colorIndicator.clipsToBounds = true
        colorIndicator.layer.cornerRadius = 30
        
        contentView.backgroundColor = .white
        
        
    }
        
    
    func setupData(_ data: BoulderingAttempt) {
        
        colorIndicator.backgroundColor = .setBoulderColor(from: data.color)
        
    }
    

    
}
