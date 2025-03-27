//
//  BaseViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 3/27/25.
//

import Foundation

import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
