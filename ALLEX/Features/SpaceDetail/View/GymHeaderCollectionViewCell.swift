//
//  GymHeaderCollectionViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit

final class GymHeaderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView()
    
    private let titleLabel = TitleLabel()

    private let copyButton = UIButton()
    private let addressLabel = SubTitleLabel()
    

    private let instaImageView = UIImageView()
    
    private let instaButton = BaseButton()
    

    
    override func configureHierarchy() {
        contentView.addSubviews(logoImageView, titleLabel, copyButton, addressLabel)
        contentView.addSubviews(instaImageView, instaButton)

    }
    
    override func configureLayout() {
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        copyButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(16)
            
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(copyButton.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        instaImageView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(34)
            
        }
        
        instaButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.leading.equalTo(instaImageView.snp.trailing).offset(8)
        }

   
    }
    
    override func configureView() {
        
        addressLabel.numberOfLines = 0
        
        titleLabel.font = .setAllexFont(.bold_20)
        addressLabel.font = .setAllexFont(.regular_14)
        instaButton.titleLabel?.font = .setAllexFont(.regular_14)
        
        
        logoImageView.clipsToBounds = true
        instaImageView.clipsToBounds = true
        
        logoImageView.layer.cornerRadius = 30
        instaImageView.layer.cornerRadius = 17
        
        instaImageView.image = UIImage(resource: .instagram)
        instaButton.tintColor = .setAllexColor(.textPirmary)
        
        copyButton.tintColor = .setAllexColor(.textPirmary)
        copyButton.setImage(.setAllexSymbol(.document), for: .normal)
        
        copyButton.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        instaButton.addTarget(self, action: #selector(instaButtonTapped), for: .touchUpInside)
        
    }

    
    
    func configure(title: String, address: String, insta: String, imageURL: String) {
        titleLabel.text = title
        addressLabel.text = address
        instaButton.setTitle(insta, for: .normal)
        
        Task {
            do {
                let data = try await NetworkManger.shared.fetchAsycnAwait(url: imageURL)
                logoImageView.image = data
            } catch {
                logoImageView.image = .setAllexSymbol(.star)
            }
            
        }
      
    }
  
    @objc func copyText() {
         UIPasteboard.general.string = addressLabel.text  // 클립보드에 복사
         print("Text copied: \(addressLabel.text ?? "")") // 디버깅 로그
     }
    
    @objc func instaButtonTapped() {
        Profile.goToInstagram(username: (instaButton.titleLabel?.text)!)
    }
}

