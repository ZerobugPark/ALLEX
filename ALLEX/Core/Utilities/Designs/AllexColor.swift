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
        case textColor000
        case textColor005
        case textColor010
        
        var color: UIColor {
            switch self {
            case .pirmary:
                    .pirmary
            case .backGround:
                    .backGround
            case .textColor000:
                    .textColor000
            case .textColor005:
                    .textColor005
            case .textColor010:
                    .textColor010
            }
        }
    }
    
    static func setAllexColor(_ type: ColorName) -> UIColor {
        return type.color
    }
}
