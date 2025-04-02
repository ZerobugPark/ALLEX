//
//  AllexSymbol.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

extension UIImage {
    
    enum SFSymbol: String {
        case house = "house"
        case calendar = "calendar"
        case camera = "camera"
        case search = "magnifyingglass"
        case person = "person.crop.circle"
        case xmark = "xmark"
        case list = "list.bullet.clipboard"
        case video = "video"
        case location = "location"
        case star = "star"
        case starFill = "star.fill"
        case play = "play.fill"
        case paues = "pause.fill"
        case eye = "eye"
        case eyeSlash = "eye.slash"
    }

    
    
    static func setAllexSymbol(_ type: SFSymbol) -> UIImage? {
        return UIImage(systemName: type.rawValue)
    }
    
}

