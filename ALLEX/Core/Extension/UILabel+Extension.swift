//
//  UILabel+Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit


extension UILabel {
    
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedString
    }
    
}
