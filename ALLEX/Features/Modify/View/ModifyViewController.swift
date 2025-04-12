//
//  ModifyViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 4/10/25.
//

import UIKit


import RxCocoa
import RxSwift

final class ModifyViewController: BaseViewController<ModifyView, ModifyViewModel> {

    
    weak var coordinator: CalendarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mainView.tableView.register(GymListTableViewCell.self, forCellReuseIdentifier: GymListTableViewCell.id)
        
    }
    
    
    override func bind() {
        
        // 1. timePicker에서 duration을 Observable로 변경
        let timeSelected = mainView.timePicker.rx
            .controlEvent(.valueChanged)
            .map { [weak mainView] in mainView?.timePicker.countDownDuration ?? 0 }
        
        let input = ModifyViewModel.Input(spaceTextField: mainView.spaceTextField.rx.text.orEmpty, doneButtonTapped: mainView.doneButton.rx.tap.withLatestFrom(timeSelected))
        
        let output = viewModel.transform(input: input)
        
        output.gymList.drive(mainView.tableView.rx.items(cellIdentifier: GymListTableViewCell.id, cellType: GymListTableViewCell.self)) { row, element , cell in
          
            cell.setupUI(data: element)
        }.disposed(by: disposeBag)
        
        
        
        output.timeTextField.drive(with: self) { owner, time in
            owner.mainView.timeTxetFiled.text = time
            
            owner.mainView.timeTxetFiled.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        

            
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
