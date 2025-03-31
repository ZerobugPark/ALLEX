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
    private var selectedCondition: ConditionType?
    
    enum ConditionType {
        case recordWrite
        case recordVideo
    }
    
    
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
    
    
    func didSelectCondition(_ condition: ConditionType) {
        self.selectedCondition = condition
        
        presentingController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.showGymSelection()
        }
    }
    
    
    // MARK: - GymSelectionCoordinator
    private func showGymSelection() {
        if let navigationController = extractNavigationController(from: presentingController) {
            let gymSelectionCoordinator = GymSelectionCoordinator(navigationController: navigationController, sharedData: sharedData)

            gymSelectionCoordinator.onGymSelected = { [weak gymSelectionCoordinator] in
       
                guard let gymSelectionCoordinator = gymSelectionCoordinator else { return }
                
                self.handleGymSelection(gymSelectionCoordinator)
            }

            childCoordinators.append(gymSelectionCoordinator) // ✅ 여기에 올바르게 추가되었는지 확인
            print("📌 childCoordinators 추가 후: \(childCoordinators.count)개")

            gymSelectionCoordinator.start()
        } else {
            print("🚨 네비게이션 컨트롤러를 찾을 수 없습니다.")
        }
    }
    
    
    
    
    
    func showRecord() {
        
        if let navigationController = extractNavigationController(from: presentingController) {
            
            let vm = CameraViewModel(self.sharedData)
            let vc = CameraViewController(viewModel: vm)
            navigationController.pushViewController(vc, animated: true)
            
        } else {
            print("네비게이션 컨트롤러를 찾을 수 없습니다.")
        }
        
    }
    
    func showCamera() {
        
        if let navigationController = extractNavigationController(from: presentingController) {
            
            // let vm = CameraViewModel(self.sharedData)
            //let vc = CameraViewController(viewModel: vm)
            let vc = RecordViewController()
            
            navigationController.pushViewController(vc, animated: true)
            
        } else {
            print("네비게이션 컨트롤러를 찾을 수 없습니다.")
        }
        
        
    }
    
    func dismiss() {
        presentingController.dismiss(animated: true)
    }
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
    
    
}

extension CameraCoordinator {
    
    // MARK: - GymSelectionCoordinator
    private func extractNavigationController(from controller: UIViewController) -> UINavigationController? {
        
        //  presentingController의 네비게이션 컨트롤러
        if let tabBarController = controller as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            //  네비게이션 컨트롤러에서 푸시 (탭 한 뷰컨의 네비게이션 컨트롤러 사용)
            return navController
        } else if let navController = controller.navigationController {
            // 만약 presentingController가 네비게이션 컨트롤러를 갖고 있다면 그대로 사용
            return navController
        } else {
            return nil
        }
    }
    
    private func childDidFinish(_ coordinator: Coordinator) {
        // === 객체가 같은 주소를 가리키는지 비교
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
        print(childCoordinators)
    }
    
    private func handleGymSelection(_ coordinator: GymSelectionCoordinator) {
        
        print("dd")
        childDidFinish(coordinator)
        
        guard let selectedCondition else { return }
        
        switch selectedCondition {
        case .recordWrite:
            showRecord()
        case .recordVideo:
            showCamera()
        }
    }
    
}
