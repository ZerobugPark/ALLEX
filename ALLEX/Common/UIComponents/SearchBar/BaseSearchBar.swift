//
//  BaseSearchBar.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import UIKit

final class BaseSearchBar: UISearchBar {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configurationSearchBar()
        
    }
    
    
    
    private func configurationSearchBar() {
        backgroundImage = UIImage() // 배경제거 , searchBarStyle을 minial로 사용하면 배경이 제거되지만, 텍스트필드 색상 변경이 안됨
        let placeholder = "Climbing Search?"
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.textTertiary])
        
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.borderColor = UIColor.borderLight.cgColor
        searchTextField.font = .systemFont(ofSize: 14)
        
        searchTextField.clipsToBounds = true
        
        searchTextField.backgroundColor = .setAllexColor(.backGroundSecondary)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
