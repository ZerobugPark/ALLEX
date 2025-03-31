//
//  NotificationCenterManager.swift
//  ALLEX
//
//  Created by youngkyun park on 3/31/25.
//

import Foundation

import RxSwift


protocol NotificationCenterHandler {
    var name: Notification.Name { get }
}

extension NotificationCenterHandler {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(name).map { $0.object }
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
}

enum NotificationCenterManager: NotificationCenterHandler {
    case isSelected
    
    var name: Notification.Name {
        switch self {
        case .isSelected:
            return Notification.Name("Gym.Selected")
        
        }
    }
    
}
