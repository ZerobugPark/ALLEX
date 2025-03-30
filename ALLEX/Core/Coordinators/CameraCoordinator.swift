//
//  CameraCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit


final class CameraCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        print("123111")
        self.navigationController = navigationController
    }
    
    func start() {
        //let vm = HomeView()
        let vc = CameraViewController()
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    
}
