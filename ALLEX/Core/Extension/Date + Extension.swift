//
//  Date + Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 4/18/25.
//

import Foundation

extension Date {
    
    func toFormattedString() -> String {
        
        let dateFormatter = DateFormatter()
        
        // 현재 로케일 및 시간대에 맞게 설정
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        // 원하는 포맷 설정 (yyyy-MM-dd <HH:mm> EEEE -> 요일 포함)
        dateFormatter.dateFormat = "yyyy-MM-dd EEEE"
        
        // Date를 원하는 포맷으로 변환
        let formattedDate = dateFormatter.string(from: self)
        
        return formattedDate
    }
    
}
