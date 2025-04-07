//
//  StatView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import UIKit

import SnapKit

// MARK: - Helper Views
final class StatView: UIView {
    
    let valueLabel: SubTitleLabel = {
        let label = SubTitleLabel()
        label.font = .setAllexFont(.bold_16)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: TertiaryLabel = {
        let label = TertiaryLabel()
        label.font = .setAllexFont(.regular_14)
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .setAllexColor(.backGroundTertiary)
        view.layer.cornerRadius = 12
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title //나중에 키값으로 변경
        
        addSubview(containerView)
        containerView.addSubview(valueLabel)
        containerView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
}
