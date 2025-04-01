//
//  RecordTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit

import SnapKit

final class RecordTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    private let eyeButtonContainer = UIView()
    private let eyeButton = UIButton()
    
    private let stackView = UIStackView()
    
    
    private let colorIndicatorContainer = UIView()
    private let colorIndicator = UIView()
    
    let tryCountButton = CountButton()
    let successCountButton = CountButton()
    

    private let gradeLabel = TertiaryLabel(title: "")
    
    var eyeButtonAction: ((Bool) -> Void)?
    private var isEyeHidden = false
    
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubviews(eyeButtonContainer, colorIndicatorContainer, tryCountButton, successCountButton)
        
        eyeButtonContainer.addSubview(eyeButton)
        colorIndicatorContainer.addSubview(colorIndicator)
        colorIndicator.addSubview(gradeLabel)
        
    }
    
    override func configureLayout() {
        
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.self.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        
        eyeButtonContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        // 1. Eye button constraints
        eyeButton.snp.makeConstraints { make in
            make.center.equalTo(eyeButtonContainer)
            make.size.equalTo(24)
        }
        
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        
        // 2. Color indicator constraints
        colorIndicator.snp.makeConstraints { make in

            make.center.equalTo(colorIndicatorContainer)
            make.size.equalTo(40)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tryCountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
        successCountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
  
        
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        //stackView.alignment = .center
    
        
        
        // Eye button
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        
        // Color indicator
        colorIndicator.clipsToBounds = true

        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
    }
    
    
    
    
    func setupData(_ data: Bouldering) {

        colorIndicator.backgroundColor = .setBoulderColor(from: data.Color)
        gradeLabel.text = data.Difficulty
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        guard contentView.bounds.width > 0 else { return }
        
        colorIndicator.layer.cornerRadius = colorIndicator.frame.width / 2
    

    }
    
    
//    // MARK: - Actions
    @objc private func eyeButtonTapped() {
        print("butotn Tapped")
//        isHidden.toggle()
//        let eyeImage = isHidden ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
//        eyeButton.setImage(eyeImage, for: .normal)
//        
//        // 콜백 호출
//        eyeButtonAction?(isHidden)
    }
//    
//    // MARK: - Configure Cell
//    func configure(with color: UIColor, leftValue: String, rightValue: String, isHidden: Bool = false) {
//        colorIndicator.backgroundColor = color
//        leftValueLabel.text = leftValue
//        rightValueLabel.text = rightValue
//        
//        self.isHidden = isHidden
//        let eyeImage = isHidden ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
//        eyeButton.setImage(eyeImage, for: .normal)
//    }
    
    
}


// 3. Left value container constraints
//tryValueContainer.snp.makeConstraints { make in
//    make.leading.equalTo(colorIndicator.snp.trailing).offset(12)
//    make.centerY.equalToSuperview()
//    //make.width.equalTo(120)
//    make.width.equalToSuperview().multipliedBy(0.25)
//    make.height.equalTo(50)
//}
//
//// 4. Right value container constraints
//sucessValueContainer.snp.makeConstraints { make in
//    make.leading.equalTo(tryValueContainer.snp.trailing).offset(12)
//    make.centerY.equalToSuperview()
//    make.width.equalTo(120)
//   // make.width.equalToSuperview().multipliedBy(0.25)
//    make.height.equalTo(50)
//    make.trailing.equalToSuperview().offset(-12)
//}
//
//// 5. Value labels constraints
//tryValueLabel.snp.makeConstraints { make in
//    make.center.equalToSuperview()
//}
//
//sucessValueLabel.snp.makeConstraints { make in
//    make.center.equalToSuperview()
//}
