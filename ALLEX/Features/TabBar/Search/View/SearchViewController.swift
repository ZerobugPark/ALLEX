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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.register(SearchListTableViewCell.self, forCellReuseIdentifier: SearchListTableViewCell.id)
    }
    
    override func bind() {
        
        let searchText = searchBar.rx.text.orEmpty.skip(1).distinctUntilChanged().debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        
        let input = SearchListViewModel.Input(viewdidLoad: Observable.just(()), searchText: searchText)
        
        let output = viewModel.transform(input: input)
        
      
        
        output.searchResult.drive(mainView.tableView.rx.items(cellIdentifier: SearchListTableViewCell.id, cellType: SearchListTableViewCell.self)) { row, element , cell in
            
            cell.setupUI(data: element)
        
        }.disposed(by: disposeBag)
    
        
        output.infoLabel.drive(mainView.infoLabel.rx.isHidden).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchController()
    }
    private func setupSearchController() {
        self.navigationItem.titleView = searchBar
    }

    
    
    
}



