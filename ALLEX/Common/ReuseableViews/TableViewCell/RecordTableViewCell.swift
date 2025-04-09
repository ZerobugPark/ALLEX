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

enum ButtonAction {
    case addButton
    case reduceButton
}



final class RecordTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    

    let bouldering = BoulderingAttemptView()
    
    var disposeBag = DisposeBag()
    
    var tryButtonEvent: Observable<ButtonAction> = Observable.never()
    var successButtonEvent: Observable<ButtonAction> = Observable.never()
    
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
        let tryTapObservable = tryTapGesture.rx.event .map { _ in ButtonAction.addButton }
        let successTapObservable = successTapGesture.rx.event .map { _ in ButtonAction.addButton }
        
        let tryMinusObservable = bouldering.tryMinusButton.rx.tap.map { _ in ButtonAction.reduceButton }
        
     
        let successMinusObservable = bouldering.successMinusButton.rx.tap.map { _ in
            ButtonAction.reduceButton
        }
        
     
        
        tryButtonEvent = Observable.merge(tryTapObservable, tryMinusObservable)
        successButtonEvent = Observable.merge(successTapObservable, successMinusObservable)

    }
  
       
        
    
  
        
    
    
    

    
}
