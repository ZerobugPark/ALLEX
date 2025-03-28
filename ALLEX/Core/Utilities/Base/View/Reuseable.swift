//
//  Reuseable.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

extension UITableViewCell {
    static var id: String {
       return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var id: String {
       return String(describing: self)
    }
}

