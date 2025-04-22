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
    let defaults: UserDefaults
    
    init(key: String, empty: T, useAppGroup: Bool = false) {
        self.key = key
        self.empty = empty
        self.defaults = useAppGroup
            ? UserDefaults(suiteName: "group.Allex.zerobugPark")!
            : .standard
    }
    
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
        case isLoggedIn, nickname, startDate, latestGrade
    }
    
    @AllexUserDefaultManager(key: Key.isLoggedIn.rawValue, empty: false)
    static var isLoggedIn
    
    @AllexUserDefaultManager(key: Key.nickname.rawValue, empty: "")
    static var nickname
    
    @AllexUserDefaultManager(key: Key.startDate.rawValue, empty: "")
    static var startDate
    
    
    @AllexUserDefaultManager(key: Key.latestGrade.rawValue, empty: "", useAppGroup: true)
    static var latestGrade
   
    
}
