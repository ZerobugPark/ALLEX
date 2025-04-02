//
//  CustomView.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

final class CustomView: UIView {
    
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .backGround
    }
    
    convenience init(radius: CGFloat, bgColor: UIColor) {
        self.init()
        
        layer.cornerRadius = radius
        backgroundColor = bgColor
        clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
