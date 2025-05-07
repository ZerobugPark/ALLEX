//
//  MonthlyClimbingResultTable.swift
//  ALLEX
//
//  Created by youngkyun park on 5/7/25.
//

import Foundation

import RealmSwift


class MonthlyClimbingResultTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var month: String
    @Persisted var boulderingLists: List<BoulderingList> // 해당 폴더 안의 등반 기록들
    //향후 추가 : 자연 / 지구력 / 킬터보드
    
    convenience init(month: String, boulderingLists: [BoulderingList]) {
        self.init()
        self.month = month
        self.boulderingLists.append(objectsIn: boulderingLists)
    }
    
    //    var totalClimbTime: Int {
    //        return boulderingLists.reduce(0) { $0 + $1.climbTime }
    //    }
    //
    //    var totalClimbCount: Int {
    //        return boulderingLists.reduce(0) { $0 + $1.totalClimb }
    //    }
    //
    //    var totalSuccessCount: Int {
    //        return boulderingLists.reduce(0) { $0 + $1.totalSuccess }
    //    }
    //
    //    var successRate: Double {
    //        let totalClimbs = totalClimbCount
    //        let totalSuccess = totalSuccessCount
    //        return totalClimbs == 0 ? 0 : (Double(totalSuccess) / Double(totalClimbs)) * 100
    //    }
    //
    //    var lastGrade: String? {
    //        return boulderingLists.last?.bestGrade
    //    }
    
}

// 개별 등반 기록
class BoulderingList: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var brandId: String
    @Persisted var gymId: String
    @Persisted var climbTime: Int
    @Persisted var climbDate: Date // 등반 날짜
    @Persisted var bestGrade: String // 등반 날짜
    @Persisted var routeResults: List<RouteResult> // 루트별 난이도 저장
    
    var totalClimb: Int {
        return routeResults.reduce(0) { $0 + $1.totalClimbCount }
    }
    
    var totalSuccess: Int {
        return routeResults.reduce(0) { $0 + $1.totalSuccessCount }
    }
    
    // 전체 성공률(rate)을 계산 (0을 방지)
    var successRate: Double {
        // 0으로 나누는 것을 방지
        return totalClimb == 0 ? 0 : (Double(totalSuccess) / Double(totalClimb)) * 100
    }
    
    convenience init(brandId: String, gymId: String, climbTime: Int, climbDate: Date, bestGrade: String, routeResults: [RouteResult]) {
        self.init()
        self.gymId = gymId
        self.brandId = brandId
        self.climbTime = climbTime
        self.climbDate = climbDate
        self.bestGrade = bestGrade
        self.routeResults.append(objectsIn: routeResults)
    }
}


// 루트별 결과
class RouteResult: EmbeddedObject {
    @Persisted var level: Int  // "0 ~ 9"
    @Persisted var color: String  // 해당 난이도의 총 성공 횟수
    @Persisted var difficulty: String  // 해당 난이도의 총 성공 횟수
    @Persisted var totalClimbCount: Int  // 해당 난이도의 총 등반 횟수
    @Persisted var totalSuccessCount: Int  // 해당 난이도의 총 성공 횟수
    
    
    override required init() {
        super.init()  // 부모 클래스인 `EmbeddedObject`의 초기화 호출
    }
    
    
    init(level: Int, color: String, difficulty: String, totalClimbCount: Int, totalSuccessCount: Int) {
        self.level = level
        self.color = color
        self.difficulty = difficulty
        self.totalClimbCount = totalClimbCount
        self.totalSuccessCount = totalSuccessCount
    }
}
