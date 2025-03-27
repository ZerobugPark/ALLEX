//
//  UIStackView+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
