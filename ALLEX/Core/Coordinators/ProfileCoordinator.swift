//
//  ProfileCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

final class ProfileCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: TabBarCoordinator?
    private let navigationController: UINavigationController
    private let sharedData: SharedDataModel
 
    init(navigationController: UINavigationController, sharedData: SharedDataModel, parentCoordinator: TabBarCoordinator?) {
        self.sharedData = sharedData
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let vm = ProfileViewModel(sharedData)
        let vc = ProfileViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    func showOfficialAccount() {
        let username = Profile.officailAccount
        Profile.goToInstagram(username: username)
    }
    
    func showPrivacyPolicy() {
        if let url = URL(string: Profile.privacyPolicy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showProfileSetting() {
        let vm = SignUpViewModel()
        let vc = ProfileSettingViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    func logout() {
        parentCoordinator?.logout() //  TabBarCoordinator에게 전달
    }

    
    
    
    
}
