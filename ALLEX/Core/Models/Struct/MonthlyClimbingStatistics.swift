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
    
    init(nickName: String = "", date: String = "", tryCount: String = "0", successCount: String = "0", successRate: String = "0%" , totalTime: String = "0", latestBestGrade: String = "VB") {
        self.nickName = nickName
        self.date = date
        self.tryCount = tryCount
        self.successCount = successCount
        self.successRate = successRate
        self.totalTime = totalTime
        self.latestBestGrade = latestBestGrade
    }
    
    
}
