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
       
    }
    
    struct Output {
        
    }
    
    var disposeBag =  DisposeBag()
    
    init() {
    }
    
    
    func transform(input: Input) -> Output {
    
        
        return Output()
    }
    
    deinit {
        print("\(type(of: self)) Deinit")
    }
    
}
