//
//  BaseViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import UIKit

import RxSwift

class BaseViewController<T: BaseView, VM: BaseViewModel>: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    func bind() {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
