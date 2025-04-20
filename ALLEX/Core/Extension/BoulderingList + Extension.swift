//
//  BoulderingList + Extension.swift
//  ALLEX
//
//  Created by youngkyun park on 4/19/25.
//

import Foundation

extension BoulderingList {
    func toClimbingResults() -> [LatestResult] {
        return self.routeResults
            .filter { $0.totalClimbCount > 0 }  // totalClimbCount가 0이 아닌 것만 필터링
            .map { routeResult in
                LatestResult(
                    level: routeResult.level,
                    color: routeResult.color,
                    difficulty: routeResult.difficulty,
                    totalClimbCount: routeResult.totalClimbCount,
                    totalSuccessCount: routeResult.totalSuccessCount
                )
            }
    }
}
