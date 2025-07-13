//
//  MonthlyClimbingResultRepository.swift
//  ALLEX
//
//  Created by youngkyun park on 5/7/25.
//

import Foundation

import RealmSwift

protocol MonthlyClimbingResultRepository: Repository where T == MonthlyClimbingResultTable {
    func createMonthlyClimbingResult(boulderingList: BoulderingList, date: Date)
    func fetchLatestBoulderingList() -> BoulderingList?
    
    func findClimbingDatesInMonth(_ month: String) -> [String]
    func findBoulderingList(for date: Date) -> [BoulderingList]
    func findBoulderingSelectedList(for query: ClimbingRecordQuery) -> BoulderingList?
    
    func updateClimbingRecord(with newList: BoulderingList, query: ClimbingRecordQuery)
    
    func monthlyBoulderingStatistics() -> MonthlyClimbingStatistics
    
    func findLastBoulderingLists(limit: Int) -> [BoulderingList]
    
    func monthlyGymListStatistics() -> (totalCount: Int, mostFrequentGymID: String?, mostFrequentGymCount: Int)
    
}

final class RealmMonthlyClimbingResultRepository: RealmRepository<MonthlyClimbingResultTable>, MonthlyClimbingResultRepository {
 

    // 월별 데이터 생성
    func createMonthlyClimbingResult(boulderingList: BoulderingList, date: Date) {
        
        let month = queryDateFormat(date)
        
        // 월별 데이터 조회
        let predicate = NSPredicate(format: "month == %@", month)
        
        if let existingResult = self.fetch(predicate: predicate) {
            // 월별 데이터가 존재하면 해당 월에 boulderingList 추가
            do {
                try realm.write {
                    existingResult.boulderingLists.append(boulderingList)  // 트랜잭션 내에서 수정
                }
            } catch {
                print("Error updating monthly climbing result: \(error.localizedDescription)")
            }
        } else {
            // 월별 데이터가 없으면 새로 월별 데이터를 생성하고 boulderingList 추가
            let newMonthlyResult = MonthlyClimbingResultTable(month: month, boulderingLists: [boulderingList])
            self.create(newMonthlyResult)  // 트랜잭션 내에서 생성
            
        }
    }
    
    //가장 최근기록 불러오기 (사용자 기록 추가시)
    func fetchLatestBoulderingList() -> BoulderingList? {
        
        let month = queryDateFormat(Date())
        
        // 월별 데이터 필터링
        let predicate = NSPredicate(format: "month == %@", month) // 조건식
        
        // 해당 월의 데이터를 가져옵니다.
        if let monthlyResult = realm.objects(MonthlyClimbingResultTable.self)
            .filter(predicate)
            .first {
            
            // boulderingLists에서 가장 마지막에 저장된 항목을 가져오기
            return monthlyResult.boulderingLists.last  // 마지막으로 저장된 항목이 최신
        }
        
        return nil
    }
    
    // 선택된 달에, 이벤트가 언제있는지
    func findClimbingDatesInMonth(_ month: String) -> [String] {
        let predicate = NSPredicate(format: "month == %@", month)
        
        guard let result = realm.objects(MonthlyClimbingResultTable.self).filter(predicate).first else {
            return []
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateStrings = result.boulderingLists.map { formatter.string(from: $0.climbDate) }
        
        // 중복 제거 + 정렬
        return Array(Set(dateStrings)).sorted()
    }
    
    
    // 날짜별 볼더링 기록 조회
    func findBoulderingList(for date: Date) -> [BoulderingList] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let month = queryDateFormat(date)
        
        // 월별 데이터를 Realm에서 가져오기
        let predicate = NSPredicate(format: "month == %@", month)
        guard let monthlyData = realm.objects(MonthlyClimbingResultTable.self).filter(predicate).first else {
            return []
        }
        
        // 해당 날짜 범위의 데이터만 필터링
        let results = monthlyData.boulderingLists.filter {
            $0.climbDate >= startOfDay && $0.climbDate < endOfDay
        }
        
        return Array(results)
    }

  
    
    // 선택된 날짜의 대한 데이터 조회
    func findBoulderingSelectedList(for query: ClimbingRecordQuery) -> BoulderingList? {
        let month = queryDateFormat(query.date)
        // 월별 데이터를 찾기 위한 predicate
        let predicate = NSPredicate(format: "month == %@", month)
        
        
        // 해당 월에 대한 MonthlyClimbingResultTable 객체를 찾음
        if let monthlyResult = realm.objects(MonthlyClimbingResultTable.self).filter(predicate).first {
            // 월별 데이터 내에서 boulderingLists를 검색하고 objectId에 맞는 항목을 찾음
            return monthlyResult.boulderingLists.first(where: { $0.id == query.objectId })
        }
        
        return nil  // 해당 월에 대한 데이터가 없거나 objectId에 맞는 데이터가 없을 경우 nil 반환
    }
    
    // 업데이트 로직
    func updateClimbingRecord(with newList: BoulderingList, query: ClimbingRecordQuery) {
        
        let month = queryDateFormat(query.date)
        let predicate = NSPredicate(format: "month == %@", month)
        
        if let monthlyResult = realm.objects(MonthlyClimbingResultTable.self).filter(predicate).first {
            if let index = monthlyResult.boulderingLists.firstIndex(where: { $0.id == query.objectId }) {
                try? realm.write {
                    let deleted = removeBoulderingList(from: monthlyResult, at: index)
                    realm.delete(deleted)  // ✅ 이 줄이 작동하도록 수정됨
                }
            }
            
            ///업데이트 되면 새로운 정보를 전달 (ClimbingRecordQuery)
            let query = ClimbingRecordQuery(objectId: newList.id, date: newList.climbDate)
        
            createMonthlyClimbingResult(boulderingList: newList, date: newList.climbDate)
            /// 저장이 되면 호출
            NotificationCenterManager.isModifyRecored.post(object: query)
            
        }
    }

    // 삭제 전용 함수 (월별 결과를 전달받음)
    private func removeBoulderingList(from result: MonthlyClimbingResultTable, at index: Int) -> BoulderingList {
        let deleted = result.boulderingLists[index]  // 삭제 전 참조 확보
        result.boulderingLists.remove(at: index)
        return deleted
    }

    
    // 월별 통계
    func monthlyBoulderingStatistics() -> MonthlyClimbingStatistics {
        
        let month = queryDateFormat(Date())

        let predicate = NSPredicate(format: "month == %@", month)
        
        guard let monthlyResult = realm.objects(MonthlyClimbingResultTable.self)
            .filter(predicate)
            .first else {
            return MonthlyClimbingStatistics()
        }
        
        
        
        let nickname = LocalizedKey.greeting.rawValue.localized(with:  UserDefaultManager.nickname)
        let startDate = DateFormatterHelper.convertStringToDate(UserDefaultManager.startDate)
        let date = LocalizedKey.userId.rawValue.localized(with: (DateFormatterHelper.daysBetween(startDate, Date()) + 1))
        
        let totalClimbTime = monthlyResult.boulderingLists.reduce(0) { $0 + $1.climbTime }.toTimeFormat()
        let totalClimbCount = monthlyResult.boulderingLists.reduce(0) { $0 + $1.totalClimb }
        let totalSuccessCount = monthlyResult.boulderingLists.reduce(0) { $0 + $1.totalSuccess }
        let successRateDouble = totalClimbCount == 0 ? 0 : (Double(totalSuccessCount) / Double(totalClimbCount)) * 100
        let successRate = String(format: "%.0f%%", successRateDouble)
        
        let lastGrade = monthlyResult.boulderingLists
            .max(by: { $0.climbDate < $1.climbDate })?
            .bestGrade ?? "VB"
        
        return MonthlyClimbingStatistics(nickName: nickname, date: date, tryCount: String(totalClimbCount), successCount: String(totalSuccessCount), successRate: successRate, totalTime: totalClimbTime, latestBestGrade: lastGrade)
    }
    
    // 이번달 가장 많이 간 암장 찾기
    func monthlyGymListStatistics() -> (totalCount: Int, mostFrequentGymID: String?, mostFrequentGymCount: Int) {
        let month = queryDateFormat(Date())
        let predicate = NSPredicate(format: "month == %@", month)
        
        guard let monthlyResult = realm.objects(MonthlyClimbingResultTable.self)
            .filter(predicate)
            .first else {
            return (0, nil, 0)
        }

        let allBoulderingRecords = monthlyResult.boulderingLists

        let totalCount = allBoulderingRecords.count

        let gymIDFrequency = Dictionary(grouping: allBoulderingRecords, by: { $0.gymId })
            .mapValues { $0.count }

        let mostFrequent = gymIDFrequency.max(by: { $0.value < $1.value })
        
        return (totalCount, mostFrequent?.key, mostFrequent?.value ?? 0)
    }

    
    func findLastBoulderingLists(limit: Int) -> [BoulderingList] {
        
        let month = queryDateFormat(Date())
        
        // 월별 데이터를 Realm에서 가져오기
        let predicate = NSPredicate(format: "month == %@", month)
        guard let monthlyData = realm.objects(MonthlyClimbingResultTable.self).filter(predicate).first else {
            return []
        }
 
        let lastBoulderingLists = monthlyData.boulderingLists
            .sorted { $0.climbDate > $1.climbDate }
            .prefix(limit)

        return Array(lastBoulderingLists)
    }

    
    

}

// MARK: Helper
extension RealmMonthlyClimbingResultRepository {
    
    private func fetch(predicate: NSPredicate) -> MonthlyClimbingResultTable? {
        return realm.objects(MonthlyClimbingResultTable.self).filter(predicate).first
    }
    
    
    private func queryDateFormat(_ date: Date) -> String {
        
        // 해당 날짜가 속한 월 문자열 생성 (예: "2025-05")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: date)
    }

    
    

    
}


