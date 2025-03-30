//
//  AllexDataStruct.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

struct Brand: Mappable {
    
    var brandID: String
    var brandName: String

    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.brandName = data[1]
    }
}


struct Gym: Mappable {
    var gymID: String
    var brandID: String
    var nameKo: String
    var nameEn: String
    var countryKo: String
    var countryEn: String
    var cityKo: String
    var cityEn: String
    var addressKo: String
    var addressEn: String
    var imageURL: String
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.gymID = data[0]
        self.brandID = data[1]
        self.nameKo = data[2]
        self.nameEn = data[3]
        self.countryKo = data[4]
        self.countryEn = data[5]
        self.cityKo = data[6]
        self.cityEn = data[7]
        self.addressKo = data[8]
        self.addressEn = data[9]
        self.imageURL = data[10]
    }
}


struct GymGrades: Mappable {
    var brandID: String
    var type: String
    var minDifficulty : String?
    var maxDifficulty: String?

    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.type = data[1]
        self.minDifficulty = data[2] == "null" ? nil : data[2]
        self.maxDifficulty = data[3] == "null" ? nil : data[2]

    }
}

struct Bouldering: Mappable {
    var brandID: String
    var Color: String
    var Difficulty : String
    

    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.Color = data[1]
        self.Difficulty = data[2]

    }
}
