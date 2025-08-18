//
//  ClimbingSpaceTable.swift
//  ALLEX
//
//  Created by youngkyun park on 8/18/25.
//

import Foundation
import RealmSwift

// MARK: - Brand
final class BrandObject: Object {
    @Persisted(primaryKey: true) var brandID: String
    @Persisted var brandName: String = ""
    
    convenience init(from model: Brand) {
        self.init()
        self.brandID = model.brandID
        self.brandName = model.brandName
    }
}

// MARK: - Gym
final class GymObject: Object {
    @Persisted(primaryKey: true) var gymID: String
    @Persisted(indexed: true) var brandID: String
    @Persisted var nameKo: String = ""
    @Persisted var nameEn: String = ""
    @Persisted var countryKo: String = ""
    @Persisted var countryEn: String = ""
    @Persisted var cityKo: String = ""
    @Persisted var cityEn: String = ""
    @Persisted var addressKo: String = ""
    @Persisted var addressEn: String = ""
    @Persisted var imageURL: String = ""
    @Persisted var instaID: String = ""
    @Persisted var facilities = List<String>()
    
    convenience init(from model: Gym) {
        self.init()
        self.gymID = model.gymID
        self.brandID = model.brandID
        self.nameKo = model.nameKo
        self.nameEn = model.nameEn
        self.countryKo = model.countryKo
        self.countryEn = model.countryEn
        self.cityKo = model.cityKo
        self.cityEn = model.cityEn
        self.addressKo = model.addressKo
        self.addressEn = model.addressEn
        self.imageURL = model.imageURL
        self.instaID = model.instaID
        self.facilities.removeAll()
        model.facilities.forEach { self.facilities.append($0) }
    }
}

// MARK: - GymGrades (brandID + type 가 유일 → 합성 PK id)
final class GymGradesObject: Object {
    @Persisted(primaryKey: true) var id: String           // "\(brandID)#\(type)"
    @Persisted(indexed: true) var brandID: String
    @Persisted var type: String = ""                      // "Bouldering" | "Lead"
    @Persisted var minDifficulty: String?
    @Persisted var maxDifficulty: String?
    
    static func makeId(brandID: String, type: String) -> String { "\(brandID)#\(type)" }
    
    convenience init(from model: GymGrades) {
        self.init()
        self.id = GymGradesObject.makeId(brandID: model.brandID, type: model.type)
        self.brandID = model.brandID
        self.type = model.type
        self.minDifficulty = model.minDifficulty
        self.maxDifficulty = model.maxDifficulty
    }
}

// MARK: - Bouldering (brandID + GradeLevel 이 유일 → 합성 PK id)
final class BoulderingObject: Object {
    @Persisted(primaryKey: true) var id: String           // "\(brandID)#\(GradeLevel)"
    @Persisted(indexed: true) var brandID: String
    @Persisted var gradeLevel: String = ""
    @Persisted var color: String = ""
    @Persisted var difficulty: String = ""
    
    static func makeId(brandID: String, level: String) -> String { "\(brandID)#\(level)" }
    
    convenience init(from model: Bouldering) {
        self.init()
        self.id = BoulderingObject.makeId(brandID: model.brandID, level: model.gradeLevel)
        self.brandID = model.brandID
        self.gradeLevel = model.gradeLevel
        self.color = model.color
        self.difficulty = model.difficulty
    }
}

