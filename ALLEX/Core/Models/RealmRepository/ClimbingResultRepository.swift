//
//  ClimbingResultRepository.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import Foundation

import RealmSwift

protocol ClimbingResultRepository: Repository where T == ClimbingResultTable {
    func findLastBoulderingLists(limit: Int) -> [BoulderingList]
    func findLastBoulderingList() -> BoulderingList?
    func findBoulderingList(for date: Date) -> [BoulderingList]
    func findBoulderingMonthList(in monthString: String) -> [String]
    func findBoulderingSelectedList(by id: ObjectId) -> BoulderingList?
}

final class RealmClimbingResultRepository: RealmRepository<ClimbingResultTable>, ClimbingResultRepository {
    

    func findLastBoulderingLists(limit: Int) -> [BoulderingList] {
        let climbingResults = realm.objects(ClimbingResultTable.self)

        let lastBoulderingLists = climbingResults
            .flatMap { $0.boulderingLists }
            .sorted { $0.climbDate > $1.climbDate }
            .prefix(limit)

        return Array(lastBoulderingLists)
    }
    
    //마지막 기록
    func findLastBoulderingList() -> BoulderingList? {
        return findLastBoulderingLists(limit: 1).first
    }
    

    func findBoulderingList(for date: Date) -> [BoulderingList] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date) // 2025-04-06 00:00:00
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)! // 2025-04-07 00:00:00

        let results = realm.objects(ClimbingResultTable.self)
            .filter("ANY boulderingLists.climbDate >= %@ AND ANY boulderingLists.climbDate < %@", startOfDay, endOfDay)
        
        return results.flatMap { $0.boulderingLists.filter { $0.climbDate >= startOfDay && $0.climbDate < endOfDay } }
    }
    
    func findBoulderingMonthList(in monthString: String) -> [String] {
        let calendar = Calendar.current
        
        // "2025-04" → 연도와 월을 분리
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        guard let monthDate = dateFormatter.date(from: monthString) else { return [] }
        
        // 월의 시작과 끝 계산
        let range = calendar.range(of: .day, in: .month, for: monthDate)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))!
        let endOfMonth = calendar.date(byAdding: .day, value: range.count, to: startOfMonth)!
        
        // Realm에서 해당 월의 등반 기록 가져오기
        let results = realm.objects(ClimbingResultTable.self)
            .filter("ANY boulderingLists.climbDate >= %@ AND ANY boulderingLists.climbDate < %@", startOfMonth, endOfMonth)
        
        // Date → "yyyy-MM-dd" 변환을 위한 DateFormatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        // Set<String>으로 변환 (중복 제거)
        let uniqueDateStrings = Set(results.flatMap { $0.boulderingLists.map { outputFormatter.string(from: $0.climbDate) } })
        
        return uniqueDateStrings.sorted() // 정렬된 배열로 반환
    }
    
    
    //선택한 클라이밍 기록
    func findBoulderingSelectedList(by id: ObjectId) -> BoulderingList? {
        
        
        let climbingResults = realm.objects(ClimbingResultTable.self)
        for climbingResult in climbingResults {
            if let data = climbingResult.boulderingLists.first(where: { $0.id == id }) {
                return data
            }
        }
        
        return nil
    }

}
