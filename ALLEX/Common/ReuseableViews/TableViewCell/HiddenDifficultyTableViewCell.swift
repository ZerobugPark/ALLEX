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

// 실시간 난이도 숨김 테이블뷰 셀
final class HiddenDifficultyTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    let bouldering = HiddenDifficultyView()
    
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
        bouldering.eyeButton.setImage(.setAllexSymbol(.eye), for: .normal)
    }
        
    
    func setupData(_ data: BoulderingAttempt) {
        bouldering.colorIndicator.backgroundColor = .setBoulderColor(from: data.color)
        bouldering.gradeLabel.text = data.difficulty
        bouldering.gradeLabel.textColor = .setAllexColor(.routeColor)
        
        bouldering.tryCountButton.countLabel.text = "\(data.tryCount)"
        bouldering.successCountButton.countLabel.text = "\(data.successCount)"
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}
