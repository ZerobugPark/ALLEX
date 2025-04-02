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
    private let eyeButtonContainer = CustomView()
    let eyeButton = BaseButton()
    
    private let stackView = UIStackView()
    
    
    private let colorIndicatorContainer = CustomView()
    private let colorIndicator = CustomView()
    
    private let tryCountButton = CountButton()
    private let successCountButton = CountButton()
    
    
    private let gradeLabel = TertiaryLabel(title: "")
    
    private var isEyeHidden = false
    
    var disposeBag = DisposeBag()
    
    
    var tryButtonEvent: Observable<TryButtonAction> = Observable.never()
    var successButtonEvent: Observable<SuccessButtonAction> = Observable.never()
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubviews(eyeButtonContainer, colorIndicatorContainer, tryCountButton, successCountButton)
        
        eyeButtonContainer.addSubview(eyeButton)
        colorIndicatorContainer.addSubview(colorIndicator)
        colorIndicator.addSubview(gradeLabel)
        
    }
    
    override func configureLayout() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.self.safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        
        eyeButtonContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        // 1. Eye button constraints
        eyeButton.snp.makeConstraints { make in
            make.center.equalTo(eyeButtonContainer)
            make.size.equalTo(24)
        }
        
        colorIndicatorContainer.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(70)
        }
        
        
        // 2. Color indicator constraints
        colorIndicator.snp.makeConstraints { make in
            
            make.center.equalTo(colorIndicatorContainer)
            make.size.equalTo(40)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tryCountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
        successCountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
    }
    
    override func configureView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        // Eye button
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = .textTertiary

        
        // Color indicator
        colorIndicator.clipsToBounds = true
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        setObservable()
        
    }
    
    
    
    
    func setupData(_ data: BoulderingAttempt) {
        colorIndicator.backgroundColor = .setBoulderColor(from: data.color)
        gradeLabel.text = data.difficulty
        
        tryCountButton.countLabel.text = "\(data.tryCount)"
        successCountButton.countLabel.text = "\(data.successCount)"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        guard contentView.bounds.width > 0 else { return }
        
        colorIndicator.layer.cornerRadius = colorIndicator.frame.width / 2
        
        
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
        tryCountButton.addGestureRecognizer(tryTapGesture)
        
        let successTapGesture = UITapGestureRecognizer()
        successCountButton.addGestureRecognizer(successTapGesture)
        
        //일반타입과 롱 타입, 두개의 타입이 다르기 때문에, map을 사용해 String 타입으로 맞춤
        let tryTapObservable = tryTapGesture.rx.event .map { _ in TryButtonAction.tryButtonTap }
        let successTapObservable = successTapGesture.rx.event .map { _ in SuccessButtonAction.successButtonTap }
        
        let tryLongPressGesture = UILongPressGestureRecognizer()
        tryLongPressGesture.minimumPressDuration = 0.5
        tryCountButton.addGestureRecognizer(tryLongPressGesture)
        
        let successLongPressGesture = UILongPressGestureRecognizer()
        successLongPressGesture.minimumPressDuration = 0.5
        successCountButton.addGestureRecognizer(successLongPressGesture)
        
        
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
