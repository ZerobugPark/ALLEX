//
//  CalendarCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RealmSwift

final class CalendarCoordinator: Coordinator, ModifyCoordinating {
 
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = CalendarViewModel()
        let vc = CalendarViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    func showDetail(mode: ResultMode) {
        
        switch mode {
        case .latest:
            break
        case .detail(let query):
            let vm = DetailInfoViewModel(mode: .detail(query))
            let vc = DetailInfoViewController(viewModel: vm)
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
      
        
    }
    
    func showModify(mode: ModifyMode) {
        
        let vm = ModifyViewModel(mode: mode)
        let vc = ModifyViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
        
        
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }

    
}
