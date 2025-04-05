//
//  RecordViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import Foundation

import RxSwift
import RxCocoa

import RealmSwift

final class RecordViewModel: BaseViewModel {
    
    
    struct Input {
        let toggleTimerTrigger: ControlEvent<Void> // 타이머 토글 트리거
        let tryButtonEvent: Driver<(TryButtonAction, Int)>
        let successButtonEvent:  Driver<(SuccessButtonAction, Int)>
        let eyeButtonEvent:  Driver<(Int)>
        let eveHiddenButtonEvent:  Driver<(Int)>
        let saveButtonTapped: ControlEvent<Void>
    }
    
    
    struct Output {
        let timerString: Observable<String> // 포맷된 타이머 문자열
        let buttonStatus: Driver<Bool>
        let updateTitle: Observable<String>
        let gymGrade: Driver<[BoulderingAttempt]>
        let hiddenData: Driver<[BoulderingAttempt]>
        let updateUI: Driver<Void>
        let dismissView: Driver<Void>
    }
    
    
    var sharedData: SharedDataModel
    
    var disposeBag =  DisposeBag()
    
    let repository: any ClimbingResultRepository = RealmClimbingResultRepository()
    
    
    private let timerSubject = PublishSubject<String>()
    private var timerSubscription: Disposable?
    private var timeCount = 0
    private var isSelected = true
    
    private var gymTitle = ""
    
    private var gymGradeList: [BoulderingAttempt] = []
    private var hiddenData: [BoulderingAttempt] = []
    
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.toggleTimer(isSelected: isSelected)
        
        getGymInfo()
        
        
    }
    
    func transform(input: Input) -> Output {
        
        let buttonStatus = PublishRelay<Bool>()
        let gymGrade = BehaviorRelay(value: gymGradeList)
        let hiddenData =  BehaviorRelay(value: hiddenData)
        let updateUI = PublishRelay<Void>()
        let dismissView = PublishRelay<Void>()
        
        input.toggleTimerTrigger.bind(with: self, onNext: { owner, _ in
            
            owner.isSelected.toggle()
            owner.toggleTimer(isSelected: owner.isSelected)
            buttonStatus.accept((owner.isSelected))
            
            
        }).disposed(by: disposeBag)
        
        
        
        // 숨길 때
        input.eyeButtonEvent.drive(with: self) { owner, value in
            
            
            if let data = owner.gymGradeList.first(where: { $0.gradeLevel == value }) {
                owner.hiddenData.append(data)
                owner.gymGradeList.removeAll { $0.gradeLevel == value }
            }
            
            owner.hiddenData.sort { $0.gradeLevel < $1.gradeLevel}
            
            
            gymGrade.accept(owner.gymGradeList)
            hiddenData.accept(owner.hiddenData)
            
            
        }.disposed(by: disposeBag)
        
        
        // 히든 화면에서 탭
        input.eveHiddenButtonEvent.drive(with: self) { owner, value in
            
            if let data = owner.hiddenData.first(where: { $0.gradeLevel == value }) {
                owner.gymGradeList.append(data)
                owner.hiddenData.removeAll { $0.gradeLevel == value }
            }
            owner.gymGradeList.sort { $0.gradeLevel < $1.gradeLevel}
        
            gymGrade.accept(owner.gymGradeList)
            
            hiddenData.accept(owner.hiddenData)
            
            updateUI.accept(())
        
            
        }.disposed(by: disposeBag)
        
  
        input.tryButtonEvent.drive(with: self) { owner, value in
            
            
           
            switch value.0 {
            case .tryButtonTap:
                print(value.1)
                print(owner.gymGradeList)
                owner.gymGradeList[value.1].tryCount += 1
            case .tryButtonLongTap:
                owner.gymGradeList[value.1].tryCount = max(0, owner.gymGradeList[value.1].tryCount - 1)
            }
            
            gymGrade.accept(owner.gymGradeList)
            
        }.disposed(by: disposeBag)
        
        input.successButtonEvent.drive(with: self) { owner, value in
            switch value.0 {
            case .successButtonTap:
                owner.gymGradeList[value.1].tryCount += 1
                owner.gymGradeList[value.1].successCount += 1
            case .successButtonLongTap:
                owner.gymGradeList[value.1].successCount = max(0, owner.gymGradeList[value.1].successCount - 1)
            }
            
            gymGrade.accept(owner.gymGradeList)
            
        }.disposed(by: disposeBag)
        
        input.saveButtonTapped.bind(with: self) { owner, _ in
            
            
            if !owner.hiddenData.isEmpty {
                owner.gymGradeList.append(contentsOf: owner.hiddenData)
                owner.hiddenData.removeAll()
            }
            
            owner.savedData()
            dismissView.accept(())
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(timerString: timerSubject.asObservable(), buttonStatus: buttonStatus.asDriver(onErrorJustReturn: (false)), updateTitle: Observable.just(gymTitle), gymGrade: gymGrade.asDriver(onErrorJustReturn: []), hiddenData: hiddenData.asDriver(onErrorJustReturn: []), updateUI: updateUI.asDriver(onErrorJustReturn: ()), dismissView: dismissView.asDriver(onErrorJustReturn: ()))
    }
    
    
    private func getGymInfo() {
        let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
        
        let info = sharedData.getData(for: String.self)!
        let data = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == info[1] }
        
        gymTitle = languageCode == "en" ? data[0].nameEn : data[0].nameKo
        
        
        let gradeInfo = self.sharedData.getData(for: Bouldering.self)!.filter{  $0.brandID == info[0] }
        
        gymGradeList.append(contentsOf: gradeInfo.map {
            BoulderingAttempt(gradeLevel: Int($0.GradeLevel) ?? 0, color: $0.Color, difficulty: $0.Difficulty, tryCount: 0, successCount: 0)
        })
        
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}

// MARK: - Realm Data

extension RecordViewModel {
    
    func savedData() {
        
        
        var result: [RouteResult] = []
        
        for element in gymGradeList {
            result.append(RouteResult(level: element.gradeLevel, color: element.color, difficulty: element.difficulty, totalClimbCount: element.tryCount, totalSuccessCount: element.successCount))
        }
        
        let info = sharedData.getData(for: String.self)!
        
        
        let highestGrade = gymGradeList
            .filter({ $0.successCount > 0 }) // successCount가 1 이상인 항목만 필터링
            .max(by: { $0.gradeLevel < $1.gradeLevel })
        
        
        // info[0] = brand, info[1] = gymid
        let timeMinute = timeCount / 60
        let boulderingList = BoulderingList(brandId: info[0], gymId: info[1], climbTime: timeMinute, climbDate: Date(), bestGrade: highestGrade?.difficulty ?? "VB", routeResults: result)
        
        // List로 감싸서 전달
        let boulderingListList = List<BoulderingList>()
        boulderingListList.append(boulderingList)
        
        
        let data = ClimbingResultTable(boulderingLists: [boulderingList])
        
        repository.create(data)
        
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
