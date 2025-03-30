//
//  CalendarViewController.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import UIKit

import RxCocoa
import RxSwift


class CalendarViewController: BaseViewController<CalendarView, CalendarViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .white
    }
    
    override func bind() {
        
        let input = CalendarViewModel.Input(initdd: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        
    }
    

    

}
