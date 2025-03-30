//
//  AppCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let isLoggedIn: Bool
    
    init(navigationController: UINavigationController, isLoggedIn: Bool) {
        self.navigationController = navigationController
        self.isLoggedIn = isLoggedIn
    }
    
    
    func start() {
        if isLoggedIn {
            showHome()
        } else {
            showSignUp()
        }
    }
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        print("here")
        
    }
    
    
    private func showSignUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        
        signUpCoordinator.onSignUpCompleted =  { [weak self] in
            
            //print("herdde", self == nil, signUpCoordinator)
            guard let self = self else { return }
            
            self.childDidFinish(signUpCoordinator)
            self.showHome()
            
        }
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    
    private func childDidFinish(_ coordinator: Coordinator) {
        // === 객체가 같은 주소를 가리키는지 비교
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    
}
