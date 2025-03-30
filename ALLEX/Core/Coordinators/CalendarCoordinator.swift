//
//  CalendarCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

final class CalendarCoordinator: Coordinator {
        
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private let sharedData: SharedDataModel
 
    init(navigationController: UINavigationController, sharedData: SharedDataModel) {
        self.sharedData = sharedData
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = CalendarViewModel(sharedData)
        let vc = CalendarViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    
    }
    
    
}
