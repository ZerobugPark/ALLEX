//
//  ClimbingResult.swift
//  ALLEX
//
//  Created by youngkyun park on 4/19/25.
//

import Foundation


struct ResultData {
    var space: String
    var date: String
    var totalTryCount: String
    var totalSuccessCount: String
    var totalSuccessRate: String
    var bestGrade: String
    var excersieTime: String
    
    var results: [LatestResult]
}


struct LatestResult {
    var level: Int  // "0 ~ 9"
    var color: String  // 해당 난이도의 총 성공 횟수
    var difficulty: String  // 해당 난이도의 총 성공 횟수
    var totalClimbCount: Int  // 해당 난이도의 총 등반 횟수
    var totalSuccessCount: Int  // 해당 난이도의 총 성공 횟수
}
