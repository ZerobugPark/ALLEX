//
//  ReportViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift


final class SearchViewController: BaseViewController<SearchListView, SearchListViewModel> {
    
    private lazy var searchBar =  BaseSearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0))
    
    var coordinator: SearchCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(SearchListTableViewCell.self, forCellReuseIdentifier: SearchListTableViewCell.id)
        searchBar.showsCancelButton = true
    }
    
    override func bind() {
        
        let searchText = searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty.skip(1).distinctUntilChanged())
        
        let input = SearchListViewModel.Input(viewdidLoad: Observable.just(()), searchText: searchText, cancelButttonTap: searchBar.rx.cancelButtonClicked)
        
        let output = viewModel.transform(input: input)
        
      
        
        output.searchResult.drive(mainView.tableView.rx.items(cellIdentifier: SearchListTableViewCell.id, cellType: SearchListTableViewCell.self)) { row, element , cell in
            
            cell.setupUI(data: element)
        
        }.disposed(by: disposeBag)
        
        
        output.hideKeyboard.drive(with: self) { owner, _ in
            owner.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        output.infoLabel.drive(mainView.infoLabel.rx.isHidden).disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(Gym.self).bind(with: self) { owner, gym in
            
            owner.coordinator?.showSpaceDetail(gym.gymID)
            
        }.disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setupSearchController()
       
    }
    
    private func setupSearchController() {
        self.navigationItem.titleView = searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
   
}



