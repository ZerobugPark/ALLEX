//
//  UserDefaultManager.swift
//  ALLEX
//
//  Created by youngkyun park on 4/1/25.
//

import Foundation

@propertyWrapper struct AllexUserDefaultManager<T> {
    
    let key: String
    let empty: T
    
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

enum UserDefaultManager {
    enum Key: String {
        case isLoggedIn, nickname, startDate
    }
    
    @AllexUserDefaultManager(key: Key.isLoggedIn.rawValue, empty: false)
    static var isLoggedIn
    
    @AllexUserDefaultManager(key: Key.nickname.rawValue, empty: "")
    static var nickname
    
    // rice, water
    @AllexUserDefaultManager(key: Key.startDate.rawValue, empty: "")
    static var startDate
    
   
    
}
