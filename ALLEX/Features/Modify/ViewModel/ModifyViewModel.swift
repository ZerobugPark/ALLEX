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

struct BoulderingWithCount {
    let brandID: String
    let gradeLevel: String
    let color: String
    let difficulty : String
    var tryCount: Int
    var successCount: Int
    
}


struct BoulderingSection {
    var header: String
    var items: [Item]
}

// SectionModelType 프로토콜 준수
extension BoulderingSection: SectionModelType {
    typealias Item = BoulderingWithCount
    
    init(original: BoulderingSection, items: [Item]) {
        self = original
        self.items = items
    }
}

enum CountType {
    case successPlus, successMinus, tryPlus, tryMinus
}


final class ModifyViewModel: BaseViewModel {
    
    struct Input {
        let spaceTextField: ControlProperty<String>
        let doneButtonTapped: Observable<TimeInterval>
        let selectedGym: Driver<(String, String)>
        let countType: Driver<(CountType, String)>
        let saveButtonTapped: Observable<(ControlProperty<String>.Element, ControlProperty<String>.Element, ControlProperty<String>.Element)>
    }
    
    struct Output {
        
        let gymList: Driver<[Gym]>
        let timeTextField: Driver<String>
        let bouldering: Driver<[BoulderingSection]>
        let errorMessage: Driver<Void>
        let dismiss: Driver<Void>
    }
    
    let repository: any ClimbingResultRepository = RealmClimbingResultRepository()
    let monthlyRepository: any MonthlyClimbingStatisticsRepository = RealmMonthlyClimbingStatisticsRepository()
    
    
    var disposeBag = DisposeBag()
    
    var sharedData: SharedDataModel
    
    private var currnetGym: (String, String) = ("","")
    
    private var gymList: [Gym] = []
    
    private var boulderingData: [BoulderingSection] = []
    var totalMinutes = 0
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let outputGymList = BehaviorRelay(value: gymList)
        let userExcersisetime = PublishRelay<String>()
        let gradeList = BehaviorRelay(value: boulderingData)
        let errorMsg = PublishRelay<Void>()
        let dismiss = PublishRelay<Void>()
        
        input.spaceTextField.bind(with: self) { owner, _ in
            
            owner.gymList = owner.sharedData.getData(for: Gym.self)!
            outputGymList.accept(owner.gymList)
            
            
        }.disposed(by: disposeBag)
        
        input.selectedGym.drive(with: self) { owner, value in
            
            let bouldering = owner.sharedData.getData(for: Bouldering.self)!.filter {  $0.brandID == value.0 }.map { BoulderingWithCount(brandID: $0.brandID, gradeLevel: $0.GradeLevel, color: $0.Color, difficulty: $0.Difficulty, tryCount: 0, successCount: 0) }
            
            // 0 == brand id, 1 == gymid
            owner.currnetGym.0 = value.0
            owner.currnetGym.1 = value.1
            
            owner.boulderingData = [BoulderingSection(header: "", items: bouldering)]
            
            
            gradeList.accept(owner.boulderingData)
            
            
        }.disposed(by: disposeBag)
        
        
        input.countType.drive(with: self) { owner, value in
            
            owner.updateTryCount(for: value.0, for: value.1)
            gradeList.accept(owner.boulderingData)
            
            
        }.disposed(by: disposeBag)
        
        input.saveButtonTapped.bind(with: self) { owenr, value  in
            
            if value.0.isEmpty || value.1.isEmpty || value.2.isEmpty {
                errorMsg.accept(())
            } else {
                
                owenr.savedData(for: value.0)
                dismiss.accept(())
                NotificationCenterManager.isUpdatedRecored.post()
                
            }
            
        }.disposed(by: disposeBag)
        
        input.doneButtonTapped.bind(with: self) { owner, timeValue in
            
            let time = owner.donePressed(time: timeValue)
            userExcersisetime.accept(time)
            
        }.disposed(by: disposeBag)
        
        
        
        return Output(gymList: outputGymList.asDriver(onErrorJustReturn: []), timeTextField: userExcersisetime.asDriver(onErrorJustReturn: ""), bouldering: gradeList.asDriver(onErrorJustReturn: []), errorMessage: errorMsg.asDriver(onErrorJustReturn: ()), dismiss: dismiss.asDriver(onErrorJustReturn: ()))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension ModifyViewModel {
    
    private func updateTryCount(for type: CountType, for gradeLevel: String) {
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
    
    
    private func donePressed(time: Double) -> String {
        totalMinutes = Int(time) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        return "\(hours)시간 \(minutes)분"
    }
}

extension ModifyViewModel {
    
    func savedData(for date: String) {
        
        var result: [RouteResult] = []
        
        for element in boulderingData[0].items {
            result.append(RouteResult(level: Int(element.gradeLevel)!, color: element.color, difficulty: element.difficulty, totalClimbCount: element.tryCount, totalSuccessCount: element.successCount))
        }
        
        let highestGrade = boulderingData[0].items
            .filter({ $0.successCount > 0 }) // successCount가 1 이상인 항목만 필터링
            .max(by: { $0.gradeLevel < $1.gradeLevel })
        
        let excersiseDate = dateConvertor(date)
        
        
        // info[0] = brand, info[1] = gymid
        let timeMinute = totalMinutes
        let boulderingList = BoulderingList(brandId: currnetGym.0, gymId: currnetGym.1, climbTime: timeMinute, climbDate: excersiseDate, bestGrade: highestGrade?.difficulty ?? "VB", routeResults: result)
        
        // List로 감싸서 전달
        let boulderingListList = List<BoulderingList>()
        boulderingListList.append(boulderingList)
        
        
        let data = ClimbingResultTable(boulderingLists: [boulderingList])
        
        repository.create(data)
        
        
        let totalClimbCount = boulderingData[0].items
            .filter { $0.tryCount > 0 }
            .reduce(0) { $0 + $1.tryCount }
        
        let totalSuccessCount = boulderingData[0].items
            .filter { $0.successCount > 0 }
            .reduce(0) { $0 + $1.successCount }
        
        
        monthlyRepository.updateMonthlyStatistics(climbCount: totalClimbCount, successCount: totalSuccessCount, climbTime: timeMinute, lastGrade: highestGrade?.difficulty ?? "VB", date: excersiseDate)
        
        
        
        
    }
    
    
    private func dateConvertor(_ dateString: String) -> Date {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy. M. d."
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M. d."
        formatter.locale = Locale(identifier: "en_US_POSIX") // 항상 고정된 포맷 해석
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 기준 (Z 시간대)
        
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
}
