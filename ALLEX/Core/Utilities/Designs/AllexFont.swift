//
//  AllexFont.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

extension UIFont {
    enum FontName {
        case bold_24
        case bold_16
        case bold_14
        case bold_12
        case bold_9
        case regular_24
        case regular_16
        case regular_14
        case regular_12
        case regular_9
        case light_24
        case light_16
        case light_14
        case light_12
        case light_9
        
   
        var font: String {
            switch self {
            case .bold_24, .bold_16, .bold_14, .bold_12, .bold_9:
                return "ONEMobileOTFBold"
            case .regular_24, .regular_16, .regular_14, .regular_12, .regular_9:
                return "ONEMobileOTFRegular"
            case .light_24, .light_16, .light_14, .light_12, .light_9:
                return "ONEMobileOTFLight"
            }
        }
        
        var size: CGFloat {
            switch self {
            case .bold_24, .regular_24, .light_24:
                return 24
            case .bold_16, .regular_16, .light_16:
                return 16
            case .bold_14, .regular_14, .light_14:
                return 14
            case .bold_12, .regular_12, .light_12:
                return 12
            case .bold_9, .regular_9, .light_9:
                return 12
            }
        }
    }
    
    static func setStreamifyFont(_ type: FontName) -> UIFont {
        return UIFont(name: type.font, size: type.size)!
    }
    
}
