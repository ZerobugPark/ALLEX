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
    @Persisted var folderId: ObjectId  // 연결된 폴더
    @Persisted var month: Date  // 해당 월 (예: "2025-04-01" 등으로 저장, 월별로 저장)
    @Persisted var totalClimbTime: Double  // 해당 월의 총 등반 시간 (초 단위)
    @Persisted var averageClimbTime: Double  // 해당 월의 평균 등반 시간 (초 단위)
    @Persisted var totalClimbCount: Int  // 해당 월의 총 등반 횟수
    @Persisted var totalSuccessCount: Int  // 해당 월의 총 성공 루트 수
    @Persisted var totalRouteResults = List<RouteResultStatistics>() // 난이도별 통계
}

final class RouteResultStatistics: EmbeddedObject {
    @Persisted var level: Int  // 난이도 (0 ~ 9)
    @Persisted var totalClimbCount: Int  // 해당 난이도의 총 등반 횟수
    @Persisted var totalSuccessCount: Int  // 해당 난이도의 총 성공 횟수
}
