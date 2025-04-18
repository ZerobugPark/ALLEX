//
//  ResultViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift



final class ResultViewModel: BaseViewModel {
    
    struct Input {
       
    }
    
    struct Output {
        let setupUI: Driver<ResultData>
        
    }
    
    var disposeBag = DisposeBag()
    
    var sharedData: SharedDataModel
    
    private let repository: any ClimbingResultRepository = RealmClimbingResultRepository()
    
    private let empty = ResultData(space: "", date: "", totalTryCount: "", totalSuccessCount: "", totalSuccessRate: "", bestGrade: "", excersieTime: "", results: [])
    
    
    private var result: ResultData
    
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
        self.result = empty
        self.result = formatData()
        
        NotificationCenterManager.isUpdatedRecored.post()
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let setupUI = BehaviorRelay<ResultData>(value: result)
   
        return Output(setupUI: setupUI.asDriver(onErrorJustReturn: empty))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension ResultViewModel {
    
    
    func formatData() -> ResultData {
        
        let data = repository.findLastBoulderingList()
        
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
                          results: climbingElements.toClimbingResults())
        
    }
    
    
}

