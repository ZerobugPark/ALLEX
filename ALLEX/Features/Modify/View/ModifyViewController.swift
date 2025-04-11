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
        
        let input = ModifyViewModel.Input(spaceTextField: mainView.spaceTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.gymList.drive(mainView.tableView.rx.items(cellIdentifier: GymListTableViewCell.id, cellType: GymListTableViewCell.self)) { row, element , cell in
          
            cell.setupUI(data: element)
        }.disposed(by: disposeBag)
        
//        mainView.testButton.rx.tap.bind(with: self) { owenr, _ in
//            
//            owenr.coordinator?.showTimeSelector()
//            
//        }.disposed(by: disposeBag)
            
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
