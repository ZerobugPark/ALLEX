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
    private let navigationController: UINavigationController
    private let presentingController: UIViewController
    
    init(presentingController: UIViewController, sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.presentingController = presentingController
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let vc = PopUpViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        presentingController.present(vc, animated: true, completion: nil)
    }
    
    func showCamera() {
        
        
        let vm = CameraViewModel(sharedData)
        let vc = CameraViewController(viewModel: vm)
        presentingController.present(vc, animated: true, completion: nil)
        //navigationController.pushViewController(vc, animated: true)
        
        
    }
    
    func dismiss() {
        presentingController.dismiss(animated: true)
        showCamera()
    }
    
}
