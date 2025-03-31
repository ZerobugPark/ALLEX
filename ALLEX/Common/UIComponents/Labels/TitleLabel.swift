//
//  TitleLabel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class TitleLabel: UILabel {

    init() {
        super.init(frame: .zero)
        textColor = .setAllexColor(.textPirmary)
    }
    
    convenience init(title: String) {
        self.init()
        text = title
    }
    
    convenience init(key: LocalizedKey, title: String) {
        
        self.init()
        text = key.rawValue.localized(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
