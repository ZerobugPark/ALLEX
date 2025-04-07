//
//  String+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    //String(format)을 사용할 때, CVarArg 준수해야함
    func localized<T: CVarArg>(with: T...) -> String {
        return String(format: self.localized, arguments: with)
    }
    
}

