//
//  GymSelectionCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import UIKit

final class GymSelectionCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let sharedData: SharedDataModel
    
    var onGymSelected: (() -> Void)? // ✅ Gym 선택 후 전달할 콜백

    init(navigationController: UINavigationController, sharedData: SharedDataModel) {
        self.navigationController = navigationController
        self.sharedData = sharedData
    }
    
    func start() {
        let vm = GymSelectionViewModel(sharedData)
        let vc = GymSelectionViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showGymlist() {
        
        let vm = GymListViewModel(sharedData)
        let vc = GymListViewController(viewModel: vm)
        vc.coordinator = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.prefersGrabberVisible = true // grabber 추가
            sheet.selectedDetentIdentifier = .medium //시작 크기
        }
        
        navigationController.present(vc, animated: true)
           
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    // ✅ 암장 선택 시 콜백 실행
    func didSelectGym() {
        onGymSelected?()
    }
}
