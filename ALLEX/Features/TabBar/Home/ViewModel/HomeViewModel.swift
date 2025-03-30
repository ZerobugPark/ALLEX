//
//  HomeViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

import RxCocoa
import RxSwift


final class HomeViewModel: BaseViewModel {
    
    struct Input {
        
        let viewdidLoad: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewdidLoad.flatMap {
            NetworkManger.shared.callRequest()
            
        }.bind(with: self) { owner, response in
            
            switch response {
            case .success(let value):
                
                let brand = owner.convertToGyms(from: value[0], type: Brand.self)
                let gyms = owner.convertToGyms(from: value[1], type: Gym.self)
                let GymGrades = owner.convertToGyms(from: value[2], type: GymGrades.self)
                let Bouldering = owner.convertToGyms(from: value[3], type: Bouldering.self)
                
            case .failure(let error):
                print(error)
            }
            
            
        }.disposed(by: disposeBag)
        
        
        
        return Output()
    }
}


extension HomeViewModel {
    
    func convertToGyms<T: Mappable>(from googleSheetData: GoogleSheetData, type: T.Type) -> [T] {
        // 첫 번째 행(헤더)은 제외하고 나머지 데이터를 Gym 객체로 변환
        return googleSheetData.values.dropFirst().map { T(from: $0) }
    }
}
