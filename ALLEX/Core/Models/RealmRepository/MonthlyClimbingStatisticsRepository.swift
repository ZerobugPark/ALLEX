//
//  MonthlyClimbingStatisticsRepository.swift
//  ALLEX
//
//  Created by youngkyun park on 4/6/25.
//

import Foundation

protocol MonthlyClimbingStatisticsRepository: Repository where T == MonthlyClimbingStatistics {
    func updateMonthlyStatistics(climbCount: Int, successCount: Int, climbTime: Int, lastGrade: String)
    func getCurrentMonthStatistics() -> MonthlyClimbingStatistics?
}

final class RealmMonthlyClimbingStatisticsRepository: RealmRepository<MonthlyClimbingStatistics>, MonthlyClimbingStatisticsRepository {
    
    func getCurrentMonthStatistics() -> MonthlyClimbingStatistics? {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        
        return realm.objects(MonthlyClimbingStatistics.self)
            .filter("month == %@", startOfMonth)
            .first
    }
    
    
    func updateMonthlyStatistics(climbCount: Int, successCount: Int, climbTime: Int, lastGrade: String) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.timeZone = TimeZone.current
        
        let startOfMonth = formatter.string(from: Date()) // "2025-04" 형식으로 저장

        do {
            if let existingStatistics = realm.objects(MonthlyClimbingStatistics.self)
                .filter("month == %@", startOfMonth)
                .first {

                // 기존 데이터 업데이트
                try realm.write {
                    existingStatistics.totalClimbCount += climbCount
                    existingStatistics.totalSuccessCount += successCount
                    existingStatistics.totalClimbTime += climbTime
                    existingStatistics.sucessRate = existingStatistics.totalClimbCount > 0
                        ? (Double(existingStatistics.totalSuccessCount) / Double(existingStatistics.totalClimbCount)) * 100
                        : 0
                    existingStatistics.lastGrade = lastGrade  // 마지막 등급 업데이트
                }

            } else {
                // 새로운 데이터 생성
                let newStatistics = MonthlyClimbingStatistics()
                newStatistics.month = startOfMonth // 문자열로 저장
                newStatistics.totalClimbCount = climbCount
                newStatistics.totalSuccessCount = successCount
                newStatistics.totalClimbTime = climbTime
                newStatistics.sucessRate = climbCount > 0 ? (Double(successCount) / Double(climbCount)) * 100 : 0
                newStatistics.lastGrade = lastGrade

                try realm.write {
                    realm.add(newStatistics)
                }
            }
        } catch {
            print("❌ Failed to update monthly statistics: \(error.localizedDescription)")
        }
    }

    
}
