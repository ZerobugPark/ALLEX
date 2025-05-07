//
//  DateFormatterHelper.swift
//  ALLEX
//
//  Created by youngkyun park on 5/8/25.
//

import Foundation

enum DateFormatterHelper {
    static func convertStringToDate(_ dateString: String) -> Date? {
        let formats = [
            "yyyy-MM-dd",     // 2025-04-06
            "MMM d, yyyy",    // Apr 6, 2025
            "yyyy. M. d."     // 2025. 4. 6
        ]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
    
    static func daysBetween(_ startDate: Date?, _ endDate: Date) -> Int {
        
        guard let startDate = startDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
}
