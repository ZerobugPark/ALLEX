//
//  BaseTextField.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

class BaseTextField: UITextField {

    init() {
        super.init(frame: .zero)
        setupPaddingTextField()
        
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
