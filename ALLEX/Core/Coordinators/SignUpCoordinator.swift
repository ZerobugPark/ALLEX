//
//  SignUpCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class SignUpCoordinator: Coordinator {
    
    
    var childCoordinators: [Coordinator] = []
    
    var onSignUpCompleted: (()-> Void)?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = SignUpViewModel()
        let vc = SignUpViewController(viewModel: vm)
        vc.coordinator = self

        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishShighUp() {
        onSignUpCompleted?() // AppCoordinator가 홈으로 화면 전환
    }
     
    deinit {
           print("SignUpCoordinator deinitialized")
       }
}

