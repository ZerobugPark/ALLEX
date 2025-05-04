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
    
    enum Mode {
        case latest
        case detail(ObjectId)
    }
    
    
    struct Input {
        
    }
    
    struct Output {
        let setupUI: Driver<ResultData>
        
    }
    
    
    var disposeBag = DisposeBag()
    
    var sharedData: SharedDataModel
    
    
    private let mode: Mode
    private let repository: any ClimbingResultRepository = RealmClimbingResultRepository()
    private let empty = ResultData(space: "", date: "", totalTryCount: "", totalSuccessCount: "", totalSuccessRate: "", bestGrade: "", excersieTime: "", results: [])
    private var result: ResultData
    
    
    init(_ sharedData: SharedDataModel, mode: Mode) {
        self.sharedData = sharedData
        self.mode = mode
        self.result = empty
        self.result = formatData()
        
//        if case .latest = mode {
//            NotificationCenterManager.isUpdatedRecored.post()
//        }
        
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
    
    
//    func formatData() -> ResultData {
//        
//        let data = repository.findBoulderingSelectedList(by: id)
//        
//        guard let climbingElements = data else {
//            return empty
//        }
//        
//        let gymInfo = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == climbingElements.gymId }.first!
//        
//        return ResultData(space: Locale.preferredLanguageCode == "en" ? gymInfo.nameEn : gymInfo.nameKo,
//                          date: climbingElements.climbDate.toFormattedString(),
//                          totalTryCount:  String(climbingElements.totalClimb),
//                          totalSuccessCount: String(climbingElements.totalSuccess),
//                          totalSuccessRate: String(format: "%.0f%%", climbingElements.successRate),
//                          bestGrade: climbingElements.bestGrade,
//                          excersieTime: climbingElements.climbTime.toTimeFormat(),
//                          results: climbingElements.toClimbingResults())
////    }
    
    
    private func formatData() -> ResultData {
        let data = {
            switch mode {
            case .latest:
                return repository.findLastBoulderingList()
            case .detail(let id):
                return repository.findBoulderingSelectedList(by: id)
            }
        }()
        
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

