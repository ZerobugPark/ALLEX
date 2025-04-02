//
//  RecordTableCellViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import Foundation

import RxSwift
import RxCocoa

enum TryButtonAction {
    case tryButtonTap
    case tryButtonLongTap
}

enum SuccessButtonAction {
    case successButtonTap
    case successButtonLongTap
}

final class RecordTableCellViewModel: BaseViewModel {
    
 
    struct Input {
        let tryButtonEvent: Observable<TryButtonAction>
        let successButtonEvent: Observable<SuccessButtonAction>
    }
    
    struct Output {
        let tryCount: Driver<String>
        let successCount: Driver<String>
    }
    
    
    var disposeBag =  DisposeBag()
    
    private var tryCount = 0
    private var sucessCount = 0

    
    func transform(input: Input) -> Output {
        
        let tryTabEvent = PublishRelay<String>()
        let successTabEvent = PublishRelay<String>()

        input.tryButtonEvent.bind(with: self) { owner, action in
            switch action {
            case .tryButtonTap:
                owner.tryCount += 1
            case .tryButtonLongTap:
                owner.tryCount = owner.tryCount - 1 <= 0 ? 0 : owner.tryCount - 1
            }
            tryTabEvent.accept("\(owner.tryCount)")
        }.disposed(by: disposeBag)
        
        input.successButtonEvent.bind(with: self) { owner, action in
            switch action {
            case .successButtonTap:
                owner.sucessCount += 1
            case .successButtonLongTap:
                owner.sucessCount = owner.sucessCount - 1 <= 0 ? 0 : owner.sucessCount - 1
            }
            successTabEvent.accept("\(owner.sucessCount)")
        }.disposed(by: disposeBag)
    
    
            
        return Output(tryCount: tryTabEvent.asDriver(onErrorJustReturn: ""), successCount: successTabEvent.asDriver(onErrorJustReturn: ""))
    }
    

   
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
}
