//
//  CameraCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit


final class CameraCoordinator: Coordinator {
    
    
    var childCoordinators: [Coordinator] = []
    
    private let sharedData: SharedDataModel
    private let presentingController: UIViewController
    
    init(presentingController: UIViewController, sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.presentingController = presentingController
    }
    
    func start() {
        let vc = PopUpViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        presentingController.present(vc, animated: true, completion: nil)
    }
    
    func showRecord() {
    
        
        presentingController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            let vm = CameraViewModel(self.sharedData)
            let vc = CameraViewController(viewModel: vm)

            //  presentingController의 네비게이션 컨트롤러
            if let tabBarController = self.presentingController as? UITabBarController,
               let navController = tabBarController.selectedViewController as? UINavigationController {
                //  네비게이션 컨트롤러에서 푸시 (탭 한 뷰컨의 네비게이션 컨트롤러 사용)
                navController.pushViewController(vc, animated: true)
            } else if let navController = self.presentingController.navigationController {
                // 만약 presentingController가 네비게이션 컨트롤러를 갖고 있다면 그대로 사용
                navController.pushViewController(vc, animated: true)
            } else {
                print("네비게이션 컨트롤러를 찾을 수 없습니다.")
            }
        }
        
        
    }
    
    func showCamera() {
    
        
        presentingController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }

            let vm = CameraViewModel(self.sharedData)
            let vc = CameraViewController(viewModel: vm)

            //  presentingController의 네비게이션 컨트롤러
            if let tabBarController = self.presentingController as? UITabBarController,
               let navController = tabBarController.selectedViewController as? UINavigationController {
                //  네비게이션 컨트롤러에서 푸시 (탭 한 뷰컨의 네비게이션 컨트롤러 사용)
                navController.pushViewController(vc, animated: true)
            } else if let navController = self.presentingController.navigationController {
                // 만약 presentingController가 네비게이션 컨트롤러를 갖고 있다면 그대로 사용
                navController.pushViewController(vc, animated: true)
            } else {
                print("네비게이션 컨트롤러를 찾을 수 없습니다.")
            }
        }
        
        
    }
    
    func dismiss() {
        presentingController.dismiss(animated: true)
    }
    
}
