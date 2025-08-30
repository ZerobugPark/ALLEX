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
    
    var onGymSelected: (() -> Void)? //  Gym 선택 후 전달할 콜백

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = GymSelectionViewModel()
        let vc = GymSelectionViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showGymlist() {
        
        let vm = GymListViewModel()
        let vc = GymListViewController(viewModel: vm)
        vc.coordinator = self
        configureSheetPresentation(for: vc)
        navigationController.present(vc, animated: true)
           
    }
    
    // MARK: - Private Methods
    private func configureSheetPresentation(for viewController: UIViewController) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // Medium 크기 유지
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium
        }
    }
    
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    //  암장 선택 시 콜백 실행
    func didSelectGym() {
        
        navigationController.popViewController(animated: true)
        
        onGymSelected?()
        
    }
}
