//
//  ModifyCoordinating.swift
//  ALLEX
//
//  Created by youngkyun park on 5/5/25.
//

import Foundation
import RealmSwift

protocol ModifyCoordinating: AnyObject {
    func showDetail(mode: ResultMode)
    func showModify(mode: ModifyMode)
    func popView()
}
