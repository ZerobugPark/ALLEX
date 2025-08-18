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
            defaults.object(forKey: key) as? T ?? empty
        }
        set {
            defaults.setValue(newValue, forKey: key)
        }
    }
}

enum UserDefaultManager {
    enum Key: String {
        case isLoggedIn, nickname, startDate, latestGrade, totalExTime, successRate, databaseVersion
    }
    
    @AllexUserDefaultManager(key: Key.isLoggedIn.rawValue, empty: false)
    static var isLoggedIn
    
    @AllexUserDefaultManager(key: Key.nickname.rawValue, empty: "", useAppGroup: true)
    static var nickname
    
    @AllexUserDefaultManager(key: Key.startDate.rawValue, empty: "")
    static var startDate
    
    @AllexUserDefaultManager(key: Key.startDate.rawValue, empty: "")
    static var databaseVersion
    
    
    @AllexUserDefaultManager(key: Key.latestGrade.rawValue, empty: "VB", useAppGroup: true)
    static var latestGrade
    
    @AllexUserDefaultManager(key: Key.totalExTime.rawValue, empty: "", useAppGroup: true)
    static var totalExTime
    
    @AllexUserDefaultManager(key: Key.successRate.rawValue, empty: "", useAppGroup: true)
    static var successRate
   
    
}
