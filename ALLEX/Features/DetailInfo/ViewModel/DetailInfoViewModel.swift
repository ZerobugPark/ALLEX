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
    private var mode: ResultMode
    private var climbingRecord: ClimbingRecordQuery = ClimbingRecordQuery()

    
    private let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    private let empty = ResultData(space: "", date: "", totalTryCount: "", totalSuccessCount: "", totalSuccessRate: "", bestGrade: "", excersieTime: "", results: [])
    
    private var result: ResultData
    
    private lazy var setupUI = BehaviorRelay<ResultData>(value: result)
    
    init(_ sharedData: SharedDataModel, mode: ResultMode) {
        self.sharedData = sharedData
        self.mode = mode
        self.result = empty
        self.result = formatData()
                
        /// 업데이트 되면 데이터 수정
        let observable: Observable<ClimbingRecordQuery?> = NotificationCenterManager.isModifyRecored.addObserver()
        observable.bind(with: self) { owner, query in
            guard let query = query else { return }
            owner.mode = .detail(query)
            owner.result = owner.formatData()
            owner.setupUI.accept(owner.result)
        }.disposed(by: disposeBag)


    }
    

    
    func transform(input: Input) -> Output {
       
        let modifyButton = PublishRelay<ClimbingRecordQuery>()
        
        input.modifyButtonTapped.bind(with: self) { owner, _ in
            
            modifyButton.accept(owner.climbingRecord)
        }.disposed(by: disposeBag)
        
        
        return Output(setupUI: setupUI.asDriver(onErrorJustReturn: empty), modifyButton: modifyButton.asDriver(onErrorJustReturn: ClimbingRecordQuery()))
    }
    
    
    deinit {
        /// 실시간 기록 또는 내용 수정, 기록 추가 관련해서 상세뷰로 넘어오고, 이제 종료될 때 홈업데이트 할 수 있게 전달
        NotificationCenterManager.isUpdatedRecored.post()
        print(String(describing: self) + "Deinit")
    }
}


extension DetailInfoViewModel {
    
    private func formatData() -> ResultData {
        let data = {
            switch mode {
            case .latest:
                let data = repository.fetchLatestBoulderingList()
                climbingRecord = ClimbingRecordQuery(objectId: data!.id, date: data!.climbDate)
                return data
            case .detail(let query):
                climbingRecord = query
                let data = repository.findBoulderingSelectedList(for: query)
                return data
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

