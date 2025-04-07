//
//  BaseButton.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class BaseButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
    }
    
    convenience init(key: LocalizedKey) {
        self.init()
        configuration = configureButton(key)
    }
    
    
    private func configureButton(_ key: LocalizedKey) -> Configuration {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .setAllexColor(.backGroundTertiary)
        config.baseBackgroundColor = .setAllexColor(.textSecondary)
        config.buttonSize = .large
        config.cornerStyle = .medium
        
        // Title Setting
        var titleContainer = AttributeContainer()
        titleContainer.font = .setAllexFont(.bold_16)
        let title = key.rawValue.localized(with: "")
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        return config
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
