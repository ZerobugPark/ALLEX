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

final class RecordTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    private let eyeButtonContainer = UIView()
    private let eyeButton = UIButton()
    
    private let stackView = UIStackView()
    
    
    private let colorIndicatorContainer = UIView()
    private let colorIndicator = UIView()
    
    private let tryCountButton = CountButton()
    private let successCountButton = CountButton()
    
    
    private let gradeLabel = TertiaryLabel(title: "")
    
    private var isEyeHidden = false
    
    private let viewModel = RecordTableCellViewModel()
    private let disposeBag = DisposeBag()
    
    
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
        eyeButton.tintColor = .gray
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        
        // Color indicator
        colorIndicator.clipsToBounds = true
        
        gradeLabel.font = .setAllexFont(.bold_12)
        gradeLabel.textAlignment = .center
        
        bind()
        
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
    
    
    
    
    // MARK: - Actions
    @objc private func eyeButtonTapped() {
        print("butotn Tapped")
        
    }
    
}

extension RecordTableViewCell {
    
    private func bind() {
        
        
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
        
        
        let tryButtonEvent = Observable.merge(tryTapObservable, tryLongTapObservable)
        let successButtonEvent = Observable.merge(successTapObservable, successLongTapObservable)
        
        
        let input = RecordTableCellViewModel.Input(tryButtonEvent: tryButtonEvent, successButtonEvent: successButtonEvent)
        
        let output = viewModel.transform(input: input)
        
        output.tryCount.drive(tryCountButton.countLabel.rx.text).disposed(by: disposeBag)
        output.successCount.drive(successCountButton.countLabel.rx.text).disposed(by: disposeBag)
        
        
        
    }
    
    
    private func createLongPressObservable<T>(for gesture: UILongPressGestureRecognizer, action: T) -> Observable<T> {
        return gesture.rx.event
            .flatMapLatest { gesture -> Observable<T> in
                if gesture.state == .began {
                    return Observable.concat(
                        Observable.just(action), // 처음 눌렀을 때 한 번 방출
                        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance) // 이후 0.5초마다 방출
                            .map { _ in action }
                    )
                } else if gesture.state == .ended || gesture.state == .cancelled {
                    return Observable.empty() // 손을 떼면 이벤트 중지
                } else {
                    return Observable.never()
                }
            }
    }
    
}
