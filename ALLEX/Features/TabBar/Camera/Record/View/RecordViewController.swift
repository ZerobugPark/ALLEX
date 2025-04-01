//
//  RecordViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import RxSwift
import RxCocoa

final class RecordViewController: BaseViewController<RecordView, RecordViewModel> {

    
    var coordinator: CameraCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.recordView.tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.id)

    }
    
    override func bind() {

       
        let input = RecordViewModel.Input(toggleTimerTrigger: mainView.timeRecord.timeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.gymGrade.drive(mainView.recordView.tableView.rx.items(cellIdentifier: RecordTableViewCell.id, cellType: RecordTableViewCell.self)){ row, element, cell in
            
            cell.setupData(element)
            
        }.disposed(by: disposeBag)
        
        
        output.buttonStatus.drive(mainView.timeRecord.timeButton.rx.isSelected).disposed(by: disposeBag)
        
        
        output.timerString
            .observe(on:MainScheduler.instance) // UI 업데이트는 메인 스레드에서
            .bind(to: mainView.timeRecord.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updateTitle.bind(to: mainView.titleLable.rx.text).disposed(by: disposeBag)
    
        mainView.backButton.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.dismiss()
        }.disposed(by: disposeBag)
        
        
    }
    

}

//extension RecordViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return activities.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.id, for: indexPath) as? RecordTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let activity = activities[indexPath.row]
//        cell.configure(
//            with: activity.color,
//            leftValue: activity.leftValue,
//            rightValue: activity.rightValue,
//            isHidden: activity.isHidden
//        )
//        
//        // 히든 버튼 액션 설정
//        cell.eyeButtonAction = { [weak self] isHidden in
//           
//            self?.handleEyeButtonTap(isHidden: isHidden, at: i)
//            
//           
//            
//            // 데이터 업데이트
//            self?.activities[indexPath.row].isHidden = isHidden
//        }
//        
//        return cell
//    }
//    
//    func handleEyeButtonTap(isHidden: Bool, at indexPath: IndexPath) {
//          // 데이터 업데이트
//          activities[indexPath.row].isHidden = isHidden
//          
//          // 베이스뷰의 메서드 호출
//        mainView.toggleHiddenView(isHidden: isHidden)
//      }
//  
//}
