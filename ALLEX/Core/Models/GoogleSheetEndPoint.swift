//
//  GoogleSheetEndPoint.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import Foundation

enum GoogleSheetEndPoint {
    
    case brand
    case gym
    case gymGrades
    case boulderingRoutes
    case leadRoutes
    
    var path: String {
        switch self {
        case .brand:
            return "/values/BrandID/"
        case .gym:
            return "/values/Gyms/"
        case .gymGrades:
            return "/values/GymGrades/"
        case .boulderingRoutes:
            return "/values/BoulderingRoutes/"
        case .leadRoutes:
            return "/values/LeadRoutes/"
        }
    }
    
    var stringURL: String {
        let baseUrl = "https://sheets.googleapis.com/v4/spreadsheets/"
        return baseUrl + GoogleAPI.spreadsheetID  + path
    }
    
}
