//
//  Locale+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 4/9/25.
//

import Foundation

extension Locale {
    
    static var isEnglish: Bool {
        return preferredLanguageCode == "en"
    }
    
    static let preferredLanguageCode: String = {
        return (Locale.preferredLanguages.first ?? "en").split(separator: "-").first.map(String.init) ?? "en"
    }()
}
