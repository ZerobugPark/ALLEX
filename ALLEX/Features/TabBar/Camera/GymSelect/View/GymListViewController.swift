//
//  GymListViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

import RxCocoa
import RxSwift


final class GymListViewController: BaseViewController<GymListView, GymListViewModel> {
    
    
    var coordinator: GymSelectionCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(GymListTableViewCell.self, forCellReuseIdentifier: GymListTableViewCell.id)

    }
    
    override func bind() {
        
        let selectedGym = PublishRelay<String>()
        
        let searchText =  mainView.searchBar.rx.text.orEmpty.distinctUntilChanged().debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        
        
        let input = GymListViewModel.Input(viewDidLoad: Observable.just(()),
                                           searchText: searchText, selectedGym: selectedGym.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.list.drive(mainView.tableView.rx.items(cellIdentifier: GymListTableViewCell.id, cellType: GymListTableViewCell.self)) { row, element , cell in
            
            cell.setupUI(data: element)
            

        }.disposed(by: disposeBag)
        
        
        
        mainView.tableView.rx.modelSelected(Gym.self).bind(with: self) { owner, value in
            
            selectedGym.accept(value.gymID)
            
            
        }.disposed(by: disposeBag)
        
        
        output.dismiss.drive(with: self) { owner, _ in
            print("heress")
            owner.coordinator?.dismiss()
            
        }.disposed(by: disposeBag)
             
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
 

}
