//
//  ModifyCollectionViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/12/25.
//

import UIKit
import SnapKit

import RxSwift
import RxCocoa

final class ModifyCollectionViewCell: BaseCollectionViewCell {
    
    
    let bouldering = ClimbLogUnitView()
    
    
    var disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        
        contentView.addSubview(bouldering)
    }
    
    
    override func configureLayout() {
        
        bouldering.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureView() {
        
        
        bouldering.backgroundColor = .setAllexColor(.backGroundSecondary)
    }
    
    func setupData(_ data: BoulderingWithCount) {
        bouldering.colorIndicator.backgroundColor = .setBoulderColor(from: data.color)
        bouldering.gradeLabel.text = data.difficulty
        bouldering.gradeLabel.textColor = .setAllexColor(.routeColor)
        
        
        bouldering.tryCountLabel.text = "\(data.tryCount)"
        bouldering.successCountLabel.text = "\(data.successCount)"
        
     
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        guard contentView.bounds.width > 0 else { return }
        
        bouldering.colorIndicator.layer.cornerRadius = bouldering.colorIndicator.frame.width / 2
        
        
    }
    
    
    
}
