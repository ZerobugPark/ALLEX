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
       
    }
    
    struct Output {
        
    }
    
    var disposeBag =  DisposeBag()
    
    init(_ sharedData: SharedDataModel) {
        self.sharedData = sharedData
    }
    
    
    func transform(input: Input) -> Output {
    
        
        return Output()
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}
