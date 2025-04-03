//
//  SearchListViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/3/25.
//

import Foundation

import RxCocoa
import RxSwift


final class SearchListViewModel: BaseViewModel {
    
    struct Input {
        
        let viewdidLoad: Observable<Void>
    }
    
    struct Output {
        let searchResult: Driver<[Gym]>
        let infoLabel: Driver<Bool>
        
    }
    
    
    private var originData: [Gym] = []
    
    var disposeBag = DisposeBag()
    
    private var sharedData: SharedDataModel
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
        
    }

    
    
    func transform(input: Input) -> Output {
        
        let searchResult = BehaviorRelay(value: originData)
        let infoLabel = BehaviorRelay(value: true)
        
        input.viewdidLoad.bind(with: self) { owner, _ in
            owner.originData =  owner.sharedData.getData(for: Gym.self)!
            
            searchResult.accept(owner.originData)
            infoLabel.accept(true)
            
        }.disposed(by: disposeBag)

        
        return Output(searchResult: searchResult.asDriver(onErrorJustReturn: []), infoLabel: infoLabel.asDriver(onErrorJustReturn: true))
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}
