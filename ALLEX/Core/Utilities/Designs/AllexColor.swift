//
//  AllexColor.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

extension UIColor {
    
    enum ColorName {
        case pirmary
        case backGround
        case textPirmary
        case textSecondary
        case textTertiary
        
        var color: UIColor {
            switch self {
            case .pirmary:
                    .pirmary
            case .backGround:
                    .backGround
            case .textPirmary:
                    .textPirmary
            case .textSecondary:
                    .textSecondary
            case .textTertiary:
                    .textTertiary
            }
        }
    }
    
    static func setAllexColor(_ type: ColorName) -> UIColor {
        return type.color
    }
}
