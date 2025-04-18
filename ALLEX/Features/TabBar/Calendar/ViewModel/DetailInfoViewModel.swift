//
//  DetailInfoViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import Foundation

import RxCocoa
import RxSwift

import RealmSwift


final class DetailInfoViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let setupUI: Driver<ResultData>
        
    }
    
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
    
    
    var disposeBag = DisposeBag()
    
    var sharedData: SharedDataModel
    var id: ObjectId
    
    private let repository: any ClimbingResultRepository = RealmClimbingResultRepository()
    private let empty = ResultData(space: "", date: "", totalTryCount: "", totalSuccessCount: "", totalSuccessRate: "", bestGrade: "", excersieTime: "", results: [])
    private var result: ResultData
    
    
    init(_ sharedData: SharedDataModel, _ id: ObjectId) {
        self.sharedData = sharedData
        self.id = id
        self.result = empty
        self.result = formatData()
        
        // NotificationCenterManager.isUpdatedRecored.post()
    }
    
    
    
    func transform(input: Input) -> Output {
        
        
        let setupUI = BehaviorRelay<ResultData>(value: result)
        
        return Output(setupUI: setupUI.asDriver(onErrorJustReturn: empty))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension DetailInfoViewModel {
    
    
    func formatData() -> ResultData {
        
        let data = repository.findBoulderingSelectedList(by: id)
        
        guard let climbingElements = data else {
            return empty
        }
        
        let gymInfo = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == climbingElements.gymId }.first!
        
        return ResultData(space: Locale.preferredLanguageCode == "en" ? gymInfo.nameEn : gymInfo.nameKo,
                          date: climbingElements.climbDate.toFormattedString(),
                          totalTryCount:  String(climbingElements.totalClimb),
                          totalSuccessCount: String(climbingElements.totalSuccess),
                          totalSuccessRate: String(format: "%.0f%%", climbingElements.successRate),
                          bestGrade: climbingElements.bestGrade,
                          excersieTime: climbingElements.climbTime.toTimeFormat(),
                          results: getRouteResults(from: climbingElements))
        
    }
    
    
    private func getRouteResults(from boulderingList: BoulderingList) -> [LatestResult] {
        return boulderingList.routeResults
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

