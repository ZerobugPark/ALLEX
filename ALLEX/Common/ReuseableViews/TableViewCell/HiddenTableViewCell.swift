//
//  HiddenTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class HiddenTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    let bouldering = BoulderingAttemptView()
    
    var disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        contentView.addSubview(bouldering)
        
    }
    
    override func configureLayout() {
        
        bouldering.snp.makeConstraints { make in
            make.edges.equalTo(contentView.self.safeAreaLayoutGuide)
            
        }

    }
    
    override func configureView() {
        bouldering.eyeButton.setImage(.setAllexSymbol(.eye), for: .normal)
    }
        
    
    func setupData(_ data: BoulderingAttempt) {
        bouldering.colorIndicator.backgroundColor = .setBoulderColor(from: data.color)
        bouldering.gradeLabel.text = data.difficulty
        bouldering.gradeLabel.textColor = .setAllexColor(.routeColor)
        
        bouldering.tryCountButton.countLabel.text = "\(data.tryCount)"
        bouldering.successCountButton.countLabel.text = "\(data.successCount)"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        guard contentView.bounds.width > 0 else { return }
        
        bouldering.colorIndicator.layer.cornerRadius = bouldering.colorIndicator.frame.width / 2
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    

    
}
