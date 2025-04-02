//
//  RecordTableCellViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

//import Foundation
//
//import RxSwift
//import RxCocoa
//
//enum TryButtonAction {
//    case tryButtonTap
//    case tryButtonLongTap
//}
//
//enum SuccessButtonAction {
//    case successButtonTap
//    case successButtonLongTap
//}
//
//final class RecordTableCellViewModel: BaseViewModel {
//    
// 
//    struct Input {
//        let tryButtonEvent: Observable<TryButtonAction>
//        let successButtonEvent: Observable<SuccessButtonAction>
//        let currentIndex: Driver<Int>
//    }
//    
//    struct Output {
//
//    }
//    
//    
//    var disposeBag =  DisposeBag()
//    
//    var tryCount: Int = 0 {
//        didSet {
//            postNotification()
//        }
//    }
//
//    var sucessCount: Int = 0 {
//        didSet {
//            postNotification()
//        }
//    }
//
//    private var index = 0
//
//    
//    func transform(input: Input) -> Output {
//
//        input.tryButtonEvent.bind(with: self) { owner, action in
//            switch action {
//            case .tryButtonTap:
//                owner.tryCount += 1
//            case .tryButtonLongTap:
//                owner.tryCount =  max(0, owner.tryCount - 1)
//            }
//        }.disposed(by: disposeBag)
//        
//        input.successButtonEvent.bind(with: self) { owner, action in
//            switch action {
//            case .successButtonTap:
//                owner.sucessCount += 1
//            case .successButtonLongTap:
//                owner.sucessCount =  max(0, owner.sucessCount - 1)
//            }
//            NotificationCenterManager.boulderingAttempt.post(object: (owner.index, owner.tryCount, owner.sucessCount))
//        }.disposed(by: disposeBag)
//        
//        input.currentIndex.drive(with: self) { owner, value in
//            owner.index = value
//        }.disposed(by: disposeBag)
//    
//    
//            
//        return Output()
//    }
//    
//
//    private func postNotification() {
//          NotificationCenterManager.boulderingAttempt.post(object: (index, tryCount, sucessCount))
//        print(index, tryCount, sucessCount)
//      }
//    
//    
//    deinit {
//        print(String(describing: self) + "Deinit")
//    }
//    
//}
