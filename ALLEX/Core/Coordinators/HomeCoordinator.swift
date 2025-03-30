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
        self.navigationController = navigationController
    }
    
    func start() {
        //let vm = HomeView()
        let vc = HomeViewController()
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    
}
