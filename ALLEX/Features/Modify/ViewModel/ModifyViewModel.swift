//
//  ModifyViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/10/25.
//

import Foundation

import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift


struct BoulderingSection {
    var header: String
    var items: [Item]
}

// SectionModelType 프로토콜 준수
extension BoulderingSection: SectionModelType {
    typealias Item = BoulderingAttempt
    
    init(original: BoulderingSection, items: [Item]) {
        self = original
        self.items = items
    }
}

enum CountType {
    case successPlus, successMinus, tryPlus, tryMinus
}

enum ModifyMode {
    case add
    case modify(_ data: ClimbingRecordQuery)
}

final class ModifyViewModel: BaseViewModel {
    
    
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let spaceTextField: ControlProperty<String>
        let doneButtonTapped: Observable<TimeInterval>
        let selectedGym: Driver<(String, String)>
        let countType: Driver<(CountType, Int)>
        let saveButtonTapped: Observable<(ControlProperty<String>.Element, ControlProperty<String>.Element, ControlProperty<String>.Element)>
    }
    
    struct Output {
        let modifyInit: Driver<ModifyInit>
        let gymList: Driver<[Gym]>
        let timeTextField: Driver<String>
        let bouldering: Driver<[BoulderingSection]>
        let errorMessage: Driver<Void>
        let popView: Driver<Void>
    }
    
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    var disposeBag = DisposeBag()
    
    private let sharedData: SharedDataModel
    private let mode: ModifyMode
    
    private var currentGym: (String, String) = ("","")
    private var gymList: [Gym] = []
    
    // 첫번째 인덱스만 사용함
    private var boulderingData: [BoulderingSection] = []
    
    private var totalMinutes = 0
    
    //Modify 전용
    private var defaultDate: Date = Date()
    
    
    init(_ sharedData: SharedDataModel, mode: ModifyMode) {
        self.sharedData = sharedData
        self.mode = mode
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let outputGymList = BehaviorRelay(value: gymList)
        let userExcersisetime = BehaviorRelay<String>(value: "")
        let gradeList = BehaviorRelay(value: boulderingData)
        let errorMsg = PublishRelay<Void>()
        let popView = PublishRelay<Void>()
        let modifyInit = BehaviorRelay(value: ModifyInit())
        
        input.viewDidLoadTrigger.bind(with: self) { owner, _ in
            
            switch owner.mode {
            case .add:
                break
            case .modify(let query):
                let data = owner.setupModifyInitialValues(for: query)
                modifyInit.accept(data)
                
                
                owner.boulderingData = [BoulderingSection(header: "", items: data.bouldering)]
                gradeList.accept(owner.boulderingData)
                break
                
            }
            
            
        }.disposed(by: disposeBag)
        
        input.spaceTextField.bind(with: self) { owner, _ in
            
            owner.gymList = owner.sharedData.getData(for: Gym.self)!
            outputGymList.accept(owner.gymList)
            
            
        }.disposed(by: disposeBag)
        
        input.selectedGym.drive(with: self) { owner, value in
            
            let bouldering = owner.sharedData.getData(for: Bouldering.self)!.filter {  $0.brandID == value.0 }.map { BoulderingAttempt(gradeLevel: Int($0.GradeLevel)!, color: $0.Color, difficulty: $0.Difficulty, tryCount: 0, successCount: 0) }
            
            // 0 == brand id, 1 == gymid
            owner.updateGymInfo(brandID: value.0, gymID: value.1)
            
            owner.boulderingData = [BoulderingSection(header: "", items: bouldering)]
            
            
            gradeList.accept(owner.boulderingData)
            
            
        }.disposed(by: disposeBag)
        
        
        input.countType.drive(with: self) { owner, value in
            
            owner.updateTryCount(for: value.0, for: value.1)
            gradeList.accept(owner.boulderingData)
            
            
        }.disposed(by: disposeBag)
        
        input.saveButtonTapped.bind(with: self) { owner, value  in
            
            switch owner.mode {
            case .add:
                if value.0.isEmpty || value.1.isEmpty || value.2.isEmpty {
                    errorMsg.accept(())
                } else {
                    
                    owner.savedData(for: value.0, self.mode)
                    popView.accept(())
                    NotificationCenterManager.isUpdatedRecored.post()
                    
                }
            case .modify:
                
                owner.savedData(for: value.0, self.mode)
                popView.accept(())
                NotificationCenterManager.isUpdatedRecored.post()
            }
            
            
            
            
        }.disposed(by: disposeBag)
        
        // MARK: 타임피커의 시간을 받음
        input.doneButtonTapped.bind(with: self) { owner, timeValue in
            let time = owner.donePressed(time: timeValue)
            userExcersisetime.accept(time)
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(modifyInit: modifyInit.asDriver(onErrorJustReturn: ModifyInit()), gymList: outputGymList.asDriver(onErrorJustReturn: []), timeTextField: userExcersisetime.asDriver(onErrorJustReturn: ""), bouldering: gradeList.asDriver(onErrorJustReturn: []), errorMessage: errorMsg.asDriver(onErrorJustReturn: ()), popView: popView.asDriver(onErrorJustReturn: ()))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


// MARK: 수정일 때, 초기값 설정
extension ModifyViewModel {
    
    
    
    struct ModifyInit {
        var date: String = ""
        var time: String = ""
        var bouldering: [BoulderingAttempt] = []
        var space: String = ""
    }
    
    private func setupModifyInitialValues(for query: ClimbingRecordQuery) -> ModifyInit {
        
        // nil일때도 있음
        let data = repository.findBoulderingSelectedList(for: query)!

        
        // 문자열 변환시 60으로 나누어진 값을 넣기 때문에, 60을 곱해줌
        totalMinutes = Int(TimeInterval(data.climbTime) * 60)
        let time = donePressed(time: Double(totalMinutes))
        
        defaultDate = data.climbDate
        let date = dateToString(defaultDate)
        
        let space = sharedData.getData(for: Gym.self)!.filter { $0.gymID == data.gymId }.first!
        
        
        let localizedSpace =  Locale.isEnglish ? space.nameEn : space.nameKo
        
        
        let bouldering = Array(data.routeResults.map {  BoulderingAttempt(gradeLevel: $0.level, color: $0.color, difficulty: $0.difficulty, tryCount: $0.totalClimbCount, successCount: $0.totalSuccessCount)
            
        })
        
        // 0 == brand id, 1 == gymid
        updateGymInfo(brandID: data.brandId, gymID: data.gymId)
        
        
        //gradeList.accept(owner.boulderingData)
        return ModifyInit(date: date, time: time, bouldering: bouldering, space: localizedSpace)
        
    }
}



// MARK: Action
extension ModifyViewModel {
    
    //브랜드 및 짐 정보 업데이트
    private func updateGymInfo(brandID: String, gymID: String) {
        currentGym.0 = brandID
        currentGym.1 = gymID
        
    }
    
    
    // 난이도별 카운트 횟수
    private func updateTryCount(for type: CountType, for gradeLevel: Int) {
        boulderingData = boulderingData.map { section in
            let updatedItems = section.items.map { item in
                var modified = item
                if item.gradeLevel == gradeLevel {
                    
                    switch type {
                    case .successPlus:
                        modified.successCount += 1
                        modified.tryCount += 1
                    case .successMinus:
                        modified.successCount -= 1
                        modified.successCount = max(0,  modified.successCount)
                    case .tryPlus:
                        modified.tryCount += 1
                    case .tryMinus:
                        if modified.successCount <=  modified.tryCount - 1 {
                            modified.tryCount -= 1
                            modified.tryCount = max(0,  modified.tryCount)
                        }
                    }
                    
                    
                }
                return modified
            }
            return BoulderingSection(header: section.header, items: updatedItems)
        }
    }
    
    
    // 타임 피커 -> 텍스트
    private func donePressed(time: Double) -> String {
        
        totalMinutes = Int(time) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        return "\(hours)시간 \(minutes)분"
    }
}

extension ModifyViewModel {
    
    
    func savedData(for date: String, _ mode: ModifyMode) {
        // 1. 필요한 데이터 준비
        let brandId = currentGym.0
        let gymId = currentGym.1
        let timeMinute = totalMinutes
        print(brandId, gymId)
        let exerciseDate = date.isEmpty ? defaultDate : dateConvertor(date)
        
        
        // 2. 통계 계산 (한 번의 순회로 여러 값 계산)
        var totalClimbCount = 0
        var totalSuccessCount = 0
        let bestGrade = boulderingData[0].items
            .filter { grade in
                // 시도 및 성공 횟수 계산
                if grade.tryCount > 0 {
                    totalClimbCount += grade.tryCount
                }
                if grade.successCount > 0 {
                    totalSuccessCount += grade.successCount
                    return true  // 성공한 항목만 반환
                }
                return false
            }
            .max(by: { $0.gradeLevel < $1.gradeLevel })
        
        let bestGradeDifficulty = bestGrade?.difficulty ?? "VB"
        
        // 3. 결과 데이터 변환
        let routeResults = boulderingData[0].items.map { element in
            RouteResult(
                level: element.gradeLevel,
                color: element.color,
                difficulty: element.difficulty,
                totalClimbCount: element.tryCount,
                totalSuccessCount: element.successCount
            )
        }
        
        // 4. 데이터 저장
        let boulderingList = BoulderingList(
            brandId: brandId,
            gymId: gymId,
            climbTime: timeMinute,
            climbDate: exerciseDate,
            bestGrade: bestGradeDifficulty,
            routeResults: routeResults
        )
        
        
        
        
        switch mode {
        case .add:
            repository.createMonthlyClimbingResult(boulderingList: boulderingList, date: exerciseDate)
        case .modify(let query):
            repository.updateClimbingRecord(with: boulderingList, query: query)
        }
        
    }
    
    
    private func dateConvertor(_ dateString: String) -> Date {
        let dateFormats = [
            "yyyy. M. d.",
            "MMM d, yyyy" // 예: "Apr 8, 2025"
        ]
        
        for format in dateFormats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        // 실패 시 현재 시간 반환 (예외 처리 or 경고 로그도 가능)
        return Date()
    }
    
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
      
        if Locale.isEnglish  {
            formatter.dateFormat = "MMM d, yyyy"
            formatter.locale = Locale(identifier: "en_US")
        } else {
            formatter.dateFormat = "yyyy. M. d."
            formatter.locale = Locale(identifier: "ko_KR") 
        }
        
        return formatter.string(from: date)
    }
    
}

