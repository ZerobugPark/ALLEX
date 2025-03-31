//
//  CalendarViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

import RxCocoa
import RxSwift


class CalendarViewModel: BaseViewModel {
    
    var sharedData: SharedDataModel
    
    struct Input {
        let initdd: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag =  DisposeBag()
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
    }
    
    
    func transform(input: Input) -> Output {
        
        input.initdd.bind(with: self) { owner, _ in
            
            
        }.disposed(by: disposeBag)
        
        return Output()
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}

