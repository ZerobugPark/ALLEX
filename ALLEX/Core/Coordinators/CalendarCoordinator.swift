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
    private let sharedData: SharedDataModel
 
    init(navigationController: UINavigationController, sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = CalendarViewModel(sharedData)
        let vc = CalendarViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    func showDetail(mode: ResultMode) {
        
        switch mode {
        case .latest:
            break
        case .detail(let id):
            let vm = DetailInfoViewModel(sharedData, mode: .detail(id))
            let vc = DetailInfoViewController(viewModel: vm)
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
      
        
    }
    
    func showModify(mode: ModifyMode) {
        
        let vm = ModifyViewModel(sharedData, mode: mode)
        let vc = ModifyViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
        
        
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }

    
}
