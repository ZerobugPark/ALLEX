//
//  TertiaryLabel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class TertiaryLabel: UILabel {

    init() {
        super.init(frame: .zero)
    }
    
    convenience init(title: String) {
        self.init()
        text = title
    }
    
    convenience init(key: LocalizedKey, title: String) {
        
        self.init()
        text = key.rawValue.localized(with: title)
        textColor = .setAllexColor(.textTertiary)
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TertiaryLabel {
    func updateTextColorBasedOnLength(count: Int) {
            
        switch count {
        case ...1:
            textColor = .setAllexColor(.unvalid)
        default:
            textColor = .setAllexColor(.valid)
            
        }
    }
}
