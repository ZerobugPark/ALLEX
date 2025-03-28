//
//  ViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backGround
        
        Task {
            do {
                
                let reuslt = try await NetworkManger.shared.fetchGoogleData()
                print(reuslt)
            } catch {
                if let error = error as? NetworkError {
                    print(error.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
                
            }
        }
        
    
        
        
    }


}

