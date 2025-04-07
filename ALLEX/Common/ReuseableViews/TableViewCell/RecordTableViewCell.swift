//
//  RecordTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit

import SnapKit

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


final class RecordTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    

    
    let bouldering = BoulderingAttemptView()
    
    var disposeBag = DisposeBag()
    
    var tryButtonEvent: Observable<TryButtonAction> = Observable.never()
    var successButtonEvent: Observable<SuccessButtonAction> = Observable.never()
    
    override func configureHierarchy() {
        contentView.addSubview(bouldering)
        
    }
    
    override func configureLayout() {
        
        bouldering.snp.makeConstraints { make in
            make.edges.equalTo(contentView.self.safeAreaLayoutGuide)
            
        }
        
    }
        
    
    override func configureView() {
        setObservable()
    }

    
    
    
    func setupData(_ data: BoulderingAttempt) {
        bouldering.colorIndicator.backgroundColor = .setBoulderColor(from: data.color)
        bouldering.gradeLabel.text = data.difficulty
        bouldering.gradeLabel.textColor = .setAllexColor(.routeColor)
        
        bouldering.tryCountButton.countLabel.text = "\(data.tryCount)"
        bouldering.successCountButton.countLabel.text = "\(data.successCount)"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        guard contentView.bounds.width > 0 else { return }
        
        bouldering.colorIndicator.layer.cornerRadius = bouldering.colorIndicator.frame.width / 2
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    

    
}

extension RecordTableViewCell {
    
    private func setObservable() {
        
        
        // MARK: - tryButton
        let tryTapGesture = UITapGestureRecognizer()
        bouldering.tryCountButton.addGestureRecognizer(tryTapGesture)
        
        let successTapGesture = UITapGestureRecognizer()
        bouldering.successCountButton.addGestureRecognizer(successTapGesture)
        
        //일반타입과 롱 타입, 두개의 타입이 다르기 때문에, map을 사용해 String 타입으로 맞춤
        let tryTapObservable = tryTapGesture.rx.event .map { _ in TryButtonAction.tryButtonTap }
        let successTapObservable = successTapGesture.rx.event .map { _ in SuccessButtonAction.successButtonTap }
        
        let tryLongPressGesture = UILongPressGestureRecognizer()
        tryLongPressGesture.minimumPressDuration = 0.5
        bouldering.tryCountButton.addGestureRecognizer(tryLongPressGesture)
        
        let successLongPressGesture = UILongPressGestureRecognizer()
        successLongPressGesture.minimumPressDuration = 0.5
        bouldering.successCountButton.addGestureRecognizer(successLongPressGesture)
        
        
        let tryLongTapObservable = createLongPressObservable(for: tryLongPressGesture, action: TryButtonAction.tryButtonLongTap)
        let successLongTapObservable = createLongPressObservable(for: successLongPressGesture, action: SuccessButtonAction.successButtonLongTap)

        
        tryButtonEvent = Observable.merge(tryTapObservable, tryLongTapObservable)
        successButtonEvent = Observable.merge(successTapObservable, successLongTapObservable)

    }
  
    
    private func createLongPressObservable<T>(for gesture: UILongPressGestureRecognizer, action: T) -> Observable<T> {
        return gesture.rx.event
            .flatMap { gesture -> Observable<T> in
                if gesture.state == .began {
                    print("👆 롱탭 시작") // ✅ 디버깅용 출력
                    return Observable.concat(
                        Observable.just(action), // 처음 눌렀을 때 한 번 방출
                        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance).debug("🔥 Interval 실행됨") // 이후 0.5초마다 방출
                            .map { _ in
                                print("🔥 롱탭 유지 중") // ✅ 유지되는지 확인 (재사용셀 이슈로 해제됨) 방법이 없을까?..
                                return action
                            }
                            .take(until: gesture.rx.event.skip(1).filter { $0.state == .ended || $0.state == .cancelled })
                    )
                } else {
                    print("🛑 롱탭 종료") // ✅ 종료되는지 확인
                    return Observable.empty()
                }
            }
    }

    
    
//    private func createLongPressObservable<T>(for gesture: UILongPressGestureRecognizer, action: T) -> Observable<T> {
//        return gesture.rx.event
//            .flatMapLatest { gesture -> Observable<T> in
//                if gesture.state == .began {
//                    return Observable.concat(
//                        Observable.just(action), // 처음 눌렀을 때 한 번 방출
//                        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance) // 이후 0.5초마다 방출
//                            .map { _ in action }
//                            .take(until: gesture.rx.event.filter { $0.state == .ended || $0.state == .cancelled })
//                    )
//                } else {
//                    return Observable.empty() // 손을 떼면 이벤트 중지
//                }
//                
//        
//            }
//    }
    
}
