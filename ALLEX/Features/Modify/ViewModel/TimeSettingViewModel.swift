//
//  TimeSettingViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/11/25.
//

import Foundation

import RxCocoa
import RxSwift

final class TimeSettingViewModel: BaseViewModel {
    
    struct Input {
       
    }
    
    struct Output {
       
    }
    
    
    var disposeBag = DisposeBag()
    

    
    
    func transform(input: Input) -> Output {
           
        return Output()
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}


extension ModifyViewModel {
    
}
