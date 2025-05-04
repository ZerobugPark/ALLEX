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
        
        guard let navigationController = extractNavigationController() else {
            handleNavigationControllerMissing()
            return
        }
        
        let gymSelectionCoordinator = GymSelectionCoordinator(navigationController: navigationController, sharedData: sharedData)
        
        gymSelectionCoordinator.onGymSelected = { [weak gymSelectionCoordinator] in
            
            guard let gymSelectionCoordinator = gymSelectionCoordinator else { return }
            
            self.handleGymSelection(gymSelectionCoordinator)
        }
        
        // 강한 참조를 유지하기 위해서 추가 (뷰는 보이지만, sharedDat는 사라짐)
        childCoordinators.append(gymSelectionCoordinator)
        gymSelectionCoordinator.start()
        
    }
    
    
    
    
    
    private func showRecord() {
        
        guard let navigationController = extractNavigationController() else {
            handleNavigationControllerMissing()
            return
        }
        
        let vm = RecordViewModel(sharedData)
        let vc = RecordViewController(viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    

    func showCamera() {
        guard let navigationController = extractNavigationController() else {
            handleNavigationControllerMissing()
            return
        }
        
        let vm = VideoCaptureViewModel(sharedData)
        let vc = VideoCaptureViewController(viewModel: vm)
        vc.coordinator = self
        vc.modalPresentationStyle = .overFullScreen // fullScreen은 화면을 덮기 때문에, 탭바가 Nil이 되는 현상이 발생 (탭바를 삭제한다는 느낌?)
        // overFullScreen은 그 화면을 유지한채 사용
        navigationController.present(vc, animated: true)
    }

    
    func showResult() {
        presentingController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            guard let navigationController = extractNavigationController() else {
                handleNavigationControllerMissing()
                return
            }
            
            let vm = DetailInfoViewModel(sharedData, mode: .latest)
            let vc = DetailInfoViewController(viewModel: vm)
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
            
    
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
    private func extractNavigationController() -> UINavigationController? {
        if let tabBarController = presentingController as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            // 탭 바 컨트롤러의 선택된 뷰컨트롤러의 네비게이션 컨트롤러 사용
            return navController
        } else if let navController = presentingController.navigationController {
            // presentingController가 네비게이션 컨트롤러를 갖고 있다면 그대로 사용
            return navController
        }
        
        return nil
    }
    
    private func handleNavigationControllerMissing() {
        print("Error: Navigation controller not found")
        // 에러 대응 코드 추가 (아마 캘린더로 등록하도록 유도해야할듯
    }
    
    private func childDidFinish(_ coordinator: Coordinator) {
        // === 객체가 같은 주소를 가리키는지 비교
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
        print(childCoordinators)
    }
    
    private func handleGymSelection(_ coordinator: GymSelectionCoordinator) {
        
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
