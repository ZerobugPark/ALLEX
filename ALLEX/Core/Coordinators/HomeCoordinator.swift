//
//  HomeCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class HomeCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        print("123")
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = HomeViewModel()
        let vc = HomeViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    
}
