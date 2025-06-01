//
//  TabBarCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import SnapKit

final class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    weak var appCoordinator: AppCoordinator?
    
    let tabBarController: UITabBarController
    
    private let sharedData = SharedDataModel()
    
    init(tabBarController: UITabBarController, appCoordinator: AppCoordinator?) {
        self.tabBarController = tabBarController
        self.appCoordinator = appCoordinator
        configureApperance()
    }
    
    
    func start() {
        
        
        
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav, sharedData: sharedData)
        homeNav.view.backgroundColor = .setAllexColor(.backGround)
        homeCoordinator.start()
        
        let calendarNav = UINavigationController()
        let calendarCoordinator = CalendarCoordinator(navigationController: calendarNav, sharedData: sharedData)
        calendarNav.view.backgroundColor = .setAllexColor(.backGround)
        calendarCoordinator.start()
        
        // 중앙에 빈 아이템 추가 (투명하게)
        let emptyVC = UIViewController()
        
        let searchNav = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNav, sharedData: sharedData)
        searchNav.view.backgroundColor = .setAllexColor(.backGround)
        searchCoordinator.start()
        
        let profileNav = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav, sharedData: sharedData, parentCoordinator: self)
        profileNav.view.backgroundColor = .setAllexColor(.backGround)
        profileCoordinator.start()
        
   
        homeNav.tabBarItem = UITabBarItem(title: nil, image: .setAllexSymbol(.house), tag: 0)
        calendarNav.tabBarItem = UITabBarItem(title: nil, image: .setAllexSymbol(.calendar), tag: 1)
        
        let emptyItem = UITabBarItem(title: "", image: nil, tag: 2)
        emptyItem.isEnabled = false // 선택 불가능하게 설정
        emptyVC.tabBarItem = emptyItem  // 빈 탭 아이템 설정
        
            
        searchNav.tabBarItem = UITabBarItem(title: nil, image: .setAllexSymbol(.search), tag: 3)
        
        profileNav.tabBarItem = UITabBarItem(title: nil, image: .setAllexSymbol(.person), tag: 4)
        
        
        tabBarController.setViewControllers([homeNav, calendarNav, emptyVC, searchNav, profileNav], animated: true)
        
        addCameraButton()
        
    }
    
    
    
    private func configureApperance() {
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        tabBarApperance.backgroundColor = .setAllexColor(.backGround)
        
        //  선택 되었을 때 컬러
        tabBarApperance.stackedLayoutAppearance.selected.iconColor = .setAllexColor(.tabBarSelected)
        
        //미선택일 때 컬러
        tabBarApperance.stackedLayoutAppearance.normal.iconColor = .setAllexColor(.tabBarUnSelected)
        
        UITabBar.appearance().standardAppearance = tabBarApperance
        
        if #available(iOS 15.0, *) {
            //ios15이상에는 이거 무조건 해줘야 함, 만약 안하면 적용 안됨
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
        }
        
    }
    
    private func addCameraButton() {
        
        // 이미지뷰 생성
        let viewContainer = UIView()
        let cameraImageView = UIImageView()
        
        viewContainer.addSubview(cameraImageView)
        // 이미지 설정
        cameraImageView.image = .setAllexSymbol(.camera)//UIImage(systemName: "camera")
        cameraImageView.backgroundColor = .clear
        cameraImageView.tintColor = .setAllexColor(.pirmary)//.tabBarUnSelected
        
        viewContainer.isUserInteractionEnabled = true // 탭 가능하도록 설정
        
        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraButtonTapped))
        viewContainer.addGestureRecognizer(tapGesture)
        
        // 탭바에 이미지뷰 추가
        tabBarController.tabBar.addSubview(viewContainer)
        
        viewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(tabBarController.tabBar.snp.width).multipliedBy(0.2)
            make.height.equalTo(tabBarController.tabBar.safeAreaLayoutGuide)
            
        }
        
        
        cameraImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.size.equalTo(tabBarController.tabBar.snp.width).multipliedBy(0.078)
            
        }
        
        
    }
    
    
    @objc func cameraButtonTapped() {
        let cameraCoordinator = CameraCoordinator(presentingController: tabBarController, sharedData: sharedData)
        cameraCoordinator.start()
    }
    
    
    
}

extension TabBarCoordinator {
    func logout() {
        appCoordinator?.logout() //  AppCoordinator에게 로그아웃 요청
    }
}
