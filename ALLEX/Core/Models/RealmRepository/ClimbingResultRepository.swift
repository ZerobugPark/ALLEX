//
//  ClimbingResultRepository.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import Foundation

protocol ClimbingResultRepository: Repository where T == ClimbingResultTable {
    func findLastBoulderingList() -> BoulderingList?
}

final class RealmClimbingResultRepository: RealmRepository<ClimbingResultTable>, ClimbingResultRepository {
    
    // 마지막 BoulderingList 가져오기
    func findLastBoulderingList() -> BoulderingList? {
        let climbingResults = realm.objects(ClimbingResultTable.self)
        
        // 가장 최근의 ClimbingResultTable을 찾고 그 안의 마지막 BoulderingList를 반환
        guard let lastClimbingResult = climbingResults.last else {
            return nil  // ClimbingResultTable이 비어있는 경우
        }
        
        // 마지막 ClimbingResultTable에서 boulderingLists의 마지막 항목을 반환
        return lastClimbingResult.boulderingLists.last
    }
    
    
    
}
