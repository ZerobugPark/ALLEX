//
//  NSObject+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 4/9/25.
//

import UIKit

extension NSObject {
    public var description: String {
        return String(describing: type(of: self))
    }
}
