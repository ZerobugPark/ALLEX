//
//  AllexDataStruct.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

struct Brand: Mappable {
    
    let brandID: String
    let brandName: String
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.brandName = data[1]
    }
}


struct Gym: Mappable {
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
        
        print(self.facilities)
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
        self.maxDifficulty = data[3] == "null" ? nil : data[2]
        
    }
}

struct Bouldering: Mappable {
    let brandID: String
    let GradeLevel: String
    let Color: String
    let Difficulty : String
    
    
    // Gym 객체 초기화하는 메서드
    init(from data: [String]) {
        self.brandID = data[0]
        self.GradeLevel = data[1]
        self.Color = data[2]
        self.Difficulty = data[3]
        
    }
}
