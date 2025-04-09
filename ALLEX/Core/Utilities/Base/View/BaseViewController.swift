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
    
    let mainView = T()
    let viewModel: VM
    
    override func loadView() {
        view = mainView
    }
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    func bind() {}
    
    
    deinit {
        print("\(description) Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
