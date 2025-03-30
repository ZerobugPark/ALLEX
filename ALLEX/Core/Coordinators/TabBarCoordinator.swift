//
//  TabBarCoordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
        
    let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        configureApperance()
    }
   
    
    func start() {
        
        //let tabBarController = UITabBarController() // TabBarController 인스턴스를 생성
        
        
        let homeNav = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeNav.view.backgroundColor = .setAllexColor(.backGround)
        homeCoordinator.start()
        
        let calendarNav = UINavigationController()
        let calendarCoordinator = CalendarCoordinator(navigationController: calendarNav)
        calendarNav.view.backgroundColor = .setAllexColor(.backGround)
        calendarCoordinator.start()
        
        let cameraNav = UINavigationController()
        let cameraCoordinator = CameraCoordinator(navigationController: cameraNav)
        cameraNav.view.backgroundColor = .setAllexColor(.backGround)
        cameraCoordinator.start()

        let reportNav = UINavigationController()
        let reportCoordinator = ReportCoordinator(navigationController: reportNav)
        reportNav.view.backgroundColor = .setAllexColor(.backGround)
        reportCoordinator.start()
        
        let profileNav = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav)
        profileNav.view.backgroundColor = .setAllexColor(.backGround)
        profileCoordinator.start()
        
             
        homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        calendarNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "calendar"), tag: 1)
        
        cameraNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 2)
     
        reportNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "chart.xyaxis.line"), tag: 3)
        
        profileNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        

        
        tabBarController.setViewControllers([homeNav, calendarNav, cameraNav, reportNav, profileNav], animated: true)

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
    
    
    
}

