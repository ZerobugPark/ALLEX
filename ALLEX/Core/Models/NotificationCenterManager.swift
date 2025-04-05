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
  
    func addObserver<T>() -> Observable<T?> {
        return NotificationCenter.default.rx.notification(name).map { $0.object as? T }
    }

    func addObserverVoid() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(name).map { _ in () }
    }


    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
}

enum NotificationCenterManager: NotificationCenterHandler {
    case isSelected
    case isChangedUserName
    
    var name: Notification.Name {
        switch self {
        case .isSelected:
            return Notification.Name("Gym.Selected")
        case .isChangedUserName:
            return Notification.Name("UserName.Changed")
        }
    }
    
}
