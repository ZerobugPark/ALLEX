//
//  SectionHeaderReusableView.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

import SnapKit

final class SectionHeaderReusableView: UICollectionReusableView {

    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .setAllexFont(.bold_16)
        label.textColor = .label
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - Configuration
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
