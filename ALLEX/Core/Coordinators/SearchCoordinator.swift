//
//  ReportCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

final class SearchCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = SearchListViewModel()
        let vc = SearchViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    func showSpaceDetail(_ gymId: String) {
        let vm = DetailSpaceViewModel(gymId)
        let vc = DetailSpaceViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}

