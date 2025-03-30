//
//  Coordinator.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import Foundation

protocol Coordinator: AnyObject {
    // 자신의 하위 코디네이터 관리를 위한 배열
    var childCoordinators: [Coordinator] { get set }
  
    // 해당 코디네이터가 관리하는 첫번째 화면 (navigation Controller를 시작)
    func start()
}
