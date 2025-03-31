//
//  AppCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    
    private let window: UIWindow
    private var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        setupNavigationBarAppearance()
    }
    
    
    
    func start() {
        showHome()
        
        //userDefaults에서 저장
        //        if isLoggedIn {
        //            showHome()
        //        } else {
        //            showSignUp()
        //        }
    }
    
    private func showHome() {
        
        let tabBarController = UITabBarController()
        let tabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        
        
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
        
    }
    
    
    private func showSignUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        
        signUpCoordinator.onSignUpCompleted =  { [weak self, weak signUpCoordinator] in
            
            guard let self = self, let signUpCoordinator = signUpCoordinator else { return }
            
            //signUpCoordinator가 강하게 캡쳐되어서 메모리 누수 발생
            self.childDidFinish(signUpCoordinator)
            self.showHome()
            
        }
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
    private func childDidFinish(_ coordinator: Coordinator) {
        // === 객체가 같은 주소를 가리키는지 비교
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
        print(childCoordinators)
    }
    
    private func setupNavigationBarAppearance() {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear] // 텍스트 숨김
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // 배경을 완전 투명하게 설정
        appearance.backButtonAppearance = backButtonAppearance
        
        appearance.backgroundColor = .setAllexColor(.backGround)
        UINavigationBar.appearance().tintColor = .setAllexColor(.textPirmary)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    
}
