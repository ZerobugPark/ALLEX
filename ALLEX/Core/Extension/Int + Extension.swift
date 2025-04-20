//
//  Int + Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 4/18/25.
//

import Foundation


extension Int {
    
    func toTimeFormat() -> String {
        
        // 시와 분으로 변환
        let hours = self / 60
        let minutes = self % 60
        
        // 두 자릿수로 포맷팅
        return String(format: "%02dh %02dm", hours, minutes)
        
        
    }
    
    
}
