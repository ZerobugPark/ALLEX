//
//  MonthlyClimbingStatistics.swift
//  ALLEX
//
//  Created by youngkyun park on 5/8/25.
//

import Foundation

struct MonthlyClimbingStatistics {
    let nickName: String
    let date: String
    let tryCount: String
    let successCount: String
    let successRate: String
    let totalTime: String
    let latestBestGrade: String
    
    
    init(nickName: String = LocalizedKey.greeting.rawValue.localized(with:  UserDefaultManager.nickname), date: String = "", tryCount: String = "0", successCount: String = "0", successRate: String = "0%" , totalTime: String = "0", latestBestGrade: String = "VB") {
        
        var resolvedDate: String
        if date.isEmpty {
            let startData = DateFormatterHelper.convertStringToDate(UserDefaultManager.startDate)
            resolvedDate = LocalizedKey.userId.rawValue.localized(with: (DateFormatterHelper.daysBetween(startData, Date()) + 1))
        } else {
            resolvedDate = date
        }
        
        
        self.nickName = nickName
        self.date = resolvedDate
        self.tryCount = tryCount
        self.successCount = successCount
        self.successRate = successRate
        self.totalTime = totalTime
        self.latestBestGrade = latestBestGrade
    
        
    }
    
    
}


struct MonthlyGymStatistics {
    
    let gymName: String
    let totalCount: Int
    let mostVisitCount: Int
    
    
    var rating: Float {
        return (Float(mostVisitCount) / Float(totalCount))
    }
    
    init(gymName: String = "", totalCount: Int = 0, mostVisitCount: Int = 0) {
        self.gymName = gymName
        self.totalCount = totalCount
        self.mostVisitCount = mostVisitCount
    }
    
}
