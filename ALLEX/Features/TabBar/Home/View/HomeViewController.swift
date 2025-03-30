//
//  HomeViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

final class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
      
    }
    



}

//Task {
//    do {
//        
//        let reuslt = try await NetworkManger.shared.fetchGoogleData()
//        print(reuslt)
//    } catch {
//        if let error = error as? NetworkError {
//            print(error.localizedDescription)
//        } else {
//            print(error.localizedDescription)
//        }
//        
//    }
//}
