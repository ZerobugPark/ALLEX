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

// 클라이밍을 최신기록을 보여줄 건지, 특정 기록을 보여줄건지
enum ResultMode {
    case latest
    case detail(_ data: ClimbingRecordQuery)
}


final class DetailInfoViewModel: BaseViewModel {
    
    
    struct Input {
        let modifyButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let setupUI: Driver<ResultData>
        let modifyButton: Driver<ClimbingRecordQuery>
    }
    
    
    var disposeBag = DisposeBag()
    
    private let sharedData: SharedDataModel
    private let mode: ResultMode
    private var climbingRecord: ClimbingRecordQuery = ClimbingRecordQuery()

    
    private let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    private let empty = ResultData(space: "", date: "", totalTryCount: "", totalSuccessCount: "", totalSuccessRate: "", bestGrade: "", excersieTime: "", results: [])
    
    private var result: ResultData
    
    
    init(_ sharedData: SharedDataModel, mode: ResultMode) {
        self.sharedData = sharedData
        self.mode = mode
        self.result = empty
        self.result = formatData()
        
        if case .latest = mode {
            NotificationCenterManager.isUpdatedRecored.post()
        }
        
         NotificationCenterManager.isUpdatedRecored.post()
    }
    

    
    func transform(input: Input) -> Output {
        
        
        let setupUI = BehaviorRelay<ResultData>(value: result)
        let modifyButton = PublishRelay<ClimbingRecordQuery>()
        
        
        input.modifyButtonTapped.bind(with: self) { owner, _ in
            
            modifyButton.accept(owner.climbingRecord)
        }.disposed(by: disposeBag)
        
        
        return Output(setupUI: setupUI.asDriver(onErrorJustReturn: empty), modifyButton: modifyButton.asDriver(onErrorJustReturn: ClimbingRecordQuery()))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension DetailInfoViewModel {
    
    private func formatData() -> ResultData {
        let data = {
            switch mode {
            case .latest:
                return repository.fetchLatestBoulderingList()
            case .detail(let query):
                return repository.findBoulderingSelectedList(for: query)
            }
        }()
        
        guard let climbingElements = data else {
            return empty
        }

        
        let gymInfo = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == climbingElements.gymId }.first!
        

        return ResultData(space: Locale.isEnglish ? gymInfo.nameEn : gymInfo.nameKo,
                                         date: climbingElements.climbDate.toFormattedString(),
                                         totalTryCount:  String(climbingElements.totalClimb),
                                         totalSuccessCount: String(climbingElements.totalSuccess),
                                         totalSuccessRate: String(format: "%.0f%%", climbingElements.successRate),
                                         bestGrade: climbingElements.bestGrade,
                                         excersieTime: climbingElements.climbTime.toTimeFormat(),
                                         results: climbingElements.toClimbingResults())
    }
}

