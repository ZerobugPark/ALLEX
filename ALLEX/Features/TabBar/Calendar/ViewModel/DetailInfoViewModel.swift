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
                          results: climbingElements.toClimbingResults())
    }
    
}

