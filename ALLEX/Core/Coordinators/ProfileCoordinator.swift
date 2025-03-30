//
//  ProfileCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

final class ProfileCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        //let vm = HomeView()
        let vc = ProfileViewController()
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    
}
