//
//  BoulderColor.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit


extension UIColor {
    
    enum BoulderColorList: String {
        
        case white
        case yellow
        case orange
        case green
        case blue
        case red
        case purple
        case gray
        case brown
        case black

        
        var color: UIColor {
            switch self {

            case .white:
                    .lightGray
            case .yellow:
                    .systemYellow
            case .orange:
                    .systemOrange
            case .green:
                    .systemGreen
            case .blue:
                    .systemBlue
            case .red:
                    .systemRed
            case .purple:
                    .systemPurple
            case .gray:
                    .systemGray
            case .brown:
                    .systemBrown
            case .black:
                    .black
            }
        }
    }
    
    static func setBoulderColor(from name: String) -> UIColor? {
        BoulderColorList(rawValue: name.lowercased())?.color
     }
}
