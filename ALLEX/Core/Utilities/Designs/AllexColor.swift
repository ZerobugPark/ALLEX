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
        case backGroundSecondary
        case backGroundTertiary
        case textPirmary
        case textSecondary
        case textTertiary
        case toolBar
        case unvalid
        case valid
        
        var color: UIColor {
            switch self {
            case .pirmary:
                    .pirmary
            case .backGround:
                    .backGround
            case .backGroundSecondary:
                    .backGroundSecondary
            case .backGroundTertiary:
                    .backGroundTertiary
            case .textPirmary:
                    .textPirmary
            case .textSecondary:
                    .textSecondary
            case .textTertiary:
                    .textTertiary
            case .toolBar:
                    .toolBar
            case .unvalid:
                    .unvalid
            case .valid:
                    .valid
            }
        }
    }
    
    static func setAllexColor(_ type: ColorName) -> UIColor {
        return type.color
    }
}
