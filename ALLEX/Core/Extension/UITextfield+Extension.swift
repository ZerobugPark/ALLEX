//
//  UITextfield+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

extension UITextField {
    
    func setupPaddingTextField() {
        self.backgroundColor = .clear
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        self.leftView = paddingView
        self.leftViewMode = .always

        self.rightView = paddingView
        self.rightViewMode = .always
                
        self.borderStyle = .roundedRect
    }
}
