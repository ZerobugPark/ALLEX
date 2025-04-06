//
//  MonthlyClimbingStatisticsTable.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import Foundation

import RealmSwift

final class MonthlyClimbingStatistics: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var month: String  // 해당 월 (예: "2025-04-01" 등으로 저장, 월별로 저장)
    @Persisted var totalClimbTime: Int  // 해당 월의 총 등반 시간 (분 단위)
    @Persisted var totalClimbCount: Int  // 해당 월의 총 등반 횟수
    @Persisted var totalSuccessCount: Int  // 해당 월의 총 성공 루트 수
    @Persisted var sucessRate: Double  // 해당 월의 성공률
    @Persisted var lastGrade: String
    
}

