//
//  AllexDataStruct.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

struct DatabaseVersion: Mappable {
    
    let version: String
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.version = data.first ?? ""
        
    }
}


struct Brand: Mappable {
    
    let brandID: String
    let brandName: String
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.brandName = data[1]
    }
    
    init(from data: BrandObject) {
        self.brandID = data.brandID
        self.brandName = data.brandName
    }
}


struct Gym: Mappable, Hashable {
    let gymID: String
    let brandID: String
    let nameKo: String
    let nameEn: String
    let countryKo: String
    let countryEn: String
    let cityKo: String
    let cityEn: String
    let addressKo: String
    let addressEn: String
    let imageURL: String
    let instaID: String
    let facilities: [String]
    
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
        self.instaID = data[11]
        
        if data.count > 12, let jsonData = data[12].data(using: .utf8) {
            self.facilities = (try? JSONDecoder().decode([String].self, from: jsonData)) ?? []
        } else {
            self.facilities = []
        }
    }
    
    init(from data: GymObject) {
        self.gymID = data.gymID
        self.brandID = data.brandID
        self.nameKo = data.nameKo
        self.nameEn = data.nameEn
        self.countryKo = data.countryKo
        self.countryEn = data.countryEn
        self.cityKo = data.cityKo
        self.cityEn = data.cityEn
        self.addressKo = data.addressKo
        self.addressEn = data.addressEn
        self.imageURL = data.imageURL
        self.instaID = data.instaID
        self.facilities = Array(data.facilities)
    }
    
}


struct GymGrades: Mappable {
    let brandID: String
    let type: String
    let minDifficulty : String?
    let maxDifficulty: String?
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.type = data[1]
        self.minDifficulty = data[2] == "null" ? nil : data[2]
        self.maxDifficulty = data[3] == "null" ? nil : data[3]
        
    }
    
    init(from data: GymGradesObject) {
        self.brandID = data.brandID
        self.type = data.type
        self.minDifficulty = data.minDifficulty
        self.maxDifficulty = data.maxDifficulty
        
    }
    
}

struct Bouldering: Mappable {
    let brandID: String
    let gradeLevel: String
    let color: String
    let difficulty : String
    
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.gradeLevel = data[1]
        self.color = data[2]
        self.difficulty = data[3]
        
    }
    
    init(from data: BoulderingObject) {
        self.brandID = data.brandID
        self.gradeLevel = data.gradeLevel
        self.color = data.color
        self.difficulty = data.difficulty
        
    }
}
