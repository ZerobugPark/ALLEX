//
//  Collection+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 4/5/25.
//

import Foundation

// MARK: - Safe subscript extension
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
