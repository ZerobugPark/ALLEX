//
//  GymSelectionViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import RxCocoa
import RxSwift

final class GymSelectionViewController: BaseViewController<GymSelectionView, GymSelectionViewModel> {

    weak var coordinator :GymSelectionCoordinator?
    
    private let gymSelected = PublishRelay<[Gym]>()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(GymListTableViewCell.self, forCellReuseIdentifier: GymListTableViewCell.id)
    }
    
    override func bind() {
        
        let input = GymSelectionViewModel.Input(selectedGym: gymSelected.asDriver(onErrorJustReturn: []))
        
        let output = viewModel.transform(input: input)
        
        output.updateGym.drive(with: self) { owner, str in
            owner.mainView.selectedGym.nameLabel.text = str
            owner.mainView.startButton.isEnabled = true
        }.disposed(by: disposeBag)
        
  
        output.recentGym.drive(mainView.tableView.rx.items(cellIdentifier: GymListTableViewCell.id, cellType: GymListTableViewCell.self)) { row, element , cell in
            
            cell.setupUI(data: element)
            
        }.disposed(by: disposeBag)
        
        output.lableStatus.drive(mainView.infoLabel.rx.isHidden).disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Gym.self).bind(with: self) { owner, value in
            
            owner.gymSelected.accept([value])
            
        }.disposed(by: disposeBag)
        
        
        mainView.selectedGym.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.showGymlist()
        }.disposed(by: disposeBag)
        
        mainView.startButton.rx.tap.bind(with: self) { owner, _ in
            owner.coordinator?.didSelectGym()
            
        }.disposed(by: disposeBag)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
 
    
    
    deinit {
        print("\(description) Deinit")
    }
    

}
