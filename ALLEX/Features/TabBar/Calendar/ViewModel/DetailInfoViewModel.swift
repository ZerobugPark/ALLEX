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
    
    struct ResultData {
        var space: String
        var date: String
        var totalTryCount: String
        var totalSuccessCount: String
        var totalSuccessRate: String
        var bestGrade: String
        var excersieTime: String
        
        var results: [LatestResult]
    }


    struct LatestResult {
        var level: Int  // "0 ~ 9"
        var color: String  // 해당 난이도의 총 성공 횟수
        var difficulty: String  // 해당 난이도의 총 성공 횟수
        var totalClimbCount: Int  // 해당 난이도의 총 등반 횟수
        var totalSuccessCount: Int  // 해당 난이도의 총 성공 횟수
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


extension DetailInfoViewModel {
    
    
    func formatData() -> ResultData {
        
        let data = repository.findBoulderingSelectedList(by: id)
        
        var resultData = ResultData(space: "", date: "", totalTryCount: "", totalSuccessCount: "", totalSuccessRate: "", bestGrade: "", excersieTime: "", results: [])
        
        
        guard let data = data else {
            
            return empty
        }
        
        
        let gymInfo = sharedData.getData(for: Gym.self)!.filter{ $0.gymID == data.gymId }
        
        
        let languageCode = (Locale.preferredLanguages.first ?? "en").split(separator: "-").first ?? ""
        
        if languageCode == "en" {
            resultData.space = gymInfo[0].nameEn
        } else {
            resultData.space = gymInfo[0].nameKo
        }
        
        resultData.bestGrade = data.bestGrade
        resultData.date = convertToDataFormat(data.climbDate)
        resultData.excersieTime = convertToTimeFormat(data.climbTime)
        resultData.totalSuccessCount = String(data.totalSuccess)
        resultData.totalTryCount = String(data.totalClimb)
        resultData.totalSuccessRate = String(format: "%.0f%%", data.successRate)
        
        resultData.results = getRouteResults(from: data)

        return resultData
    }
    
    private func convertToDataFormat(_ date: Date) -> String {
        
        
        let dateFormatter = DateFormatter()
        
        // 현재 로케일 및 시간대에 맞게 설정
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        // 원하는 포맷 설정 (yyyy-MM-dd <HH:mm> EEEE -> 요일 포함)
        dateFormatter.dateFormat = "yyyy-MM-dd EEEE"
        
        // Date를 원하는 포맷으로 변환
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    
    private func convertToTimeFormat(_ time: Int) -> String {
        
        // 시와 분으로 변환
        let hours = time / 60
        let minutes = time % 60
        
        // 두 자릿수로 포맷팅
        return String(format: "%02d:%02d", hours, minutes)
        
        
    }
    
    private func getRouteResults(from boulderingList: BoulderingList) -> [LatestResult] {
        return boulderingList.routeResults
            .filter { $0.totalClimbCount > 0 }  // totalClimbCount가 0이 아닌 것만 필터링
            .map { routeResult in
                LatestResult(
                    level: routeResult.level,
                    color: routeResult.color,
                    difficulty: routeResult.difficulty,
                    totalClimbCount: routeResult.totalClimbCount,
                    totalSuccessCount: routeResult.totalSuccessCount
                )
            }
    }
    
    
}

