//
//  RecordTableViewCell.swift
//  ALLEX
//
//  Created by youngkyun park on 4/2/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

// 실시간 기록 테이블뷰 셀
final class RecordEntryTableViewCell: BaseTableViewCell {

    let bouldering = RecordEntryView()
    
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
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    
}

extension RecordEntryTableViewCell {
    
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
