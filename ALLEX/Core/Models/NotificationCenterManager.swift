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
    case isGymSelected // 실시간 짐 선택
    case isChangedUserInfo // 프로필 수정
    case isUpdatedRecored // 기록 업데이트 (실시간 또는 유저 추가)
    
    var name: Notification.Name {
        switch self {
        case .isGymSelected:
            return Notification.Name("Gym.Selected")
        case .isChangedUserInfo:
            return Notification.Name("UserInfo.Changed")
        case .isUpdatedRecored:
            return Notification.Name("Updated.record")
        }
    }
    
}
