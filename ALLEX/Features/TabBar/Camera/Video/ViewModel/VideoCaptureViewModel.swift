//
//  VideoCaptureViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/7/25.
//

import Foundation

import RxSwift
import RxCocoa

final class VideoCaptureViewModel: BaseViewModel {
    
    struct Input {
        let selectedGrade: Driver<BoulderingAttempt>
        
    }
    
    struct Output {
        let gymGrade: Driver<[BoulderingAttempt]>
        let currentColor: Driver<String>
        
    }
    
    var disposeBag =  DisposeBag()
    
    private var gymGradeList: [BoulderingAttempt] = []
    private(set) var color = "white"
    
    let repository: any MonthlyClimbingResultRepository = RealmMonthlyClimbingResultRepository()
    
    private let spaceRepo: any ClimbingSpaceRepository = RealmClimbingSpaceRepository()
    
    init() {
        getGymInfo()
    }
    
    
    func transform(input: Input) -> Output {
        
        let gymGrade = BehaviorRelay(value: gymGradeList)
        let currentColor = BehaviorRelay(value: color)
        
        
        
        input.selectedGrade.drive(with: self) { owner, value in
            owner.color = value.color
            currentColor.accept(owner.color)
        }.disposed(by: disposeBag)
        
        return Output(
            gymGrade: gymGrade.asDriver(onErrorJustReturn: []),
            currentColor: currentColor.asDriver(onErrorJustReturn: "")
        )
    }
    
    deinit {
        print("\(type(of: self)) Deinit")
    }
    
}


extension VideoCaptureViewModel {
    private func getGymInfo() {
        
        let info = UserDefaultManager.selectedClimb

        
        guard let gradeInfo = try? spaceRepo.fetchBouldering(brandID: info[0]) else { return }
    
        color = gradeInfo.first!.color
  
        gymGradeList.append(contentsOf: gradeInfo.map {
            BoulderingAttempt(gradeLevel: Int($0.gradeLevel) ?? 0, color: $0.color, difficulty: $0.difficulty, tryCount: 0, successCount: 0)
        })
        
  
    }
    
}
