//
//  RecordViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import Foundation

import RxSwift
import RxCocoa

final class RecordViewModel: BaseViewModel {
    
    var sharedData: SharedDataModel
    
    struct Input {
        let toggleTimerTrigger: ControlEvent<Void> // 타이머 토글 트리거
    }
    
    struct Output {
        let timerString: Observable<String> // 포맷된 타이머 문자열
        let buttonStatus: Driver<Bool>
        let updateTitle: Observable<String>
        let gymGrade: Driver<[Bouldering]>
    }
    
    
    var disposeBag =  DisposeBag()
    
    
    private let timerSubject = PublishSubject<String>()
    private var timerSubscription: Disposable?
    private var timeCount = 0
    private var isSelected = true
    
    private var gymTitle = ""
    
    private var gymGradeList: [Bouldering] = []
    
    private lazy var gymGrade = BehaviorRelay(value: gymGradeList)
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.toggleTimer(isSelected: isSelected)
        
        getGymInfo()

        
    }
    
    func transform(input: Input) -> Output {
        let buttonStatus = PublishRelay<Bool>()
            
        input.toggleTimerTrigger.bind(with: self, onNext: { owner, _ in
            
            owner.isSelected.toggle()
            owner.toggleTimer(isSelected: owner.isSelected)
            buttonStatus.accept((owner.isSelected))
            
            
        }).disposed(by: disposeBag)
        
        
        return Output(timerString: timerSubject.asObservable(), buttonStatus: buttonStatus.asDriver(onErrorJustReturn: (false)), updateTitle: Observable.just(gymTitle), gymGrade: gymGrade.asDriver(onErrorJustReturn: []))
    }
    

    private func getGymInfo() {
        let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
        
        let info = sharedData.getData(for: String.self)!
        let data = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == info[1] }
 
        gymTitle = languageCode == "en" ? data[0].nameEn : data[0].nameKo
        
        
        gymGradeList = self.sharedData.getData(for: Bouldering.self)!.filter{  $0.brandID == info[0] }
        print(data)
        
        
        
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}

extension RecordViewModel {
    
    private func toggleTimer(isSelected: Bool) {
        if isSelected {
            startTimer() // 타이머 시작
        } else {
            stopTimer() // 타이머 멈춤
        }
    }
    
    private func startTimer() {
        if timerSubscription == nil {
            // 타이머 생성 및 실행 (timeCount 유지)
            timerSubscription = Observable<Int>.interval(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                .scan(timeCount) { (accumulatedTime, _) in
                    return accumulatedTime + 1
                }
                .map { [weak self] time -> String in
                    guard let self = self else { return "00:00:00" }
                    self.timeCount = time // 기존 누적 시간 유지
                    return self.updateTimeLabel(time)
                }
                .do(onNext: { [weak self] timeString in
                    self?.timerSubject.onNext(timeString)
                })
                .subscribe()
        }
    }
    
    private func stopTimer() {
        timerSubscription?.dispose() // 타이머 중지
        timerSubscription = nil // 구독이 끝났으므로 nil로 초기화
    }
    
    // 타이머 시간 포맷팅하여 레이블에 표시
    private func updateTimeLabel(_ time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        
        let timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeString
    }
}
