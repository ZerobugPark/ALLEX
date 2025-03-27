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
        
        for family in UIFont.familyNames {
            print(family)
            
            for names in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
        
        
    }


}

