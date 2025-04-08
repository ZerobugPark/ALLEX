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
    private let sharedData: SharedDataModel
 
    init(navigationController: UINavigationController, sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = SearchListViewModel(sharedData)
        let vc = SearchViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    func showSpaceDetail(_ gymId: String) {
        let vm = DetailSpaceViewModel(sharedData, gymId)
        let vc = DetailSpaceViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}

