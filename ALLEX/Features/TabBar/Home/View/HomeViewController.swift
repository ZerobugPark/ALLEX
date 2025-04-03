//
//  HomeViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift


final class HomeViewController: BaseViewController<HomeView, HomeViewModel> {

    weak var coordinator: HomeCoordinator?
    
    let repository: RealmRepository = RealmClimbingResultRepository()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setAllexColor(.backGround)
        //tabBarController?.tabBar.isUserInteractionEnabled = false // 탭전환 비활성화
        
        repository.getFileURL()
    }
    
    override func bind() {
        
        
        let input = HomeViewModel.Input(viewdidLoad: Observable.just(()))
        
        let output = viewModel.transform(input: input)
    }



}
