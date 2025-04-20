//
//  AllexFont.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

extension UIFont {
    enum FontName {
        case bold_24, bold_20, bold_16, bold_14, bold_12, bold_9
        case regular_24, regular_20, regular_16, regular_14, regular_12, regular_9
        case light_24, light_20, light_16, light_14, light_12, light_9
        
   
        var font: String {
            switch self {
            case .bold_24, .bold_20, .bold_16, .bold_14, .bold_12, .bold_9:
                return "ONEMobileOTFBold"
            case .regular_24, .regular_20, .regular_16, .regular_14, .regular_12, .regular_9:
                return "ONEMobileOTFRegular"
            case .light_24, .light_20, .light_16, .light_14, .light_12, .light_9:
                return "ONEMobileOTFLight"
            }
        }
        
        var size: CGFloat {
            switch self {
            case .bold_24, .regular_24, .light_24:
                return 24
            case .bold_20, .regular_20, .light_20:
                return 20
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
    
    static func setAllexFont(_ type: FontName) -> UIFont {
        return UIFont(name: type.font, size: type.size)!
    }
    
}
