//
//  ClimbingSpaceRepository.swift
//  ALLEX
//
//  Created by youngkyun park on 8/18/25.
//

import Foundation
import RealmSwift

// 단순: 전체 데이터 저장(업서트) + 조회만 제공
protocol ClimbingSpaceRepository {
    // 파일 위치 확인
    func fileURL() -> URL?

    // 전체 업서트 (브랜드/지점/그레이드/볼더링)
    func upsertAll(brands: [Brand], gyms: [Gym], grades: [GymGrades], boulders: [Bouldering]) throws

    // 조회
    func fetchBrands() throws -> [Brand]
    func fetchAllGyms() throws -> [Gym]
    //func fetchBouldering() throws -> [Bouldering]
    func fetchGymGrades() throws -> [GymGrades]
    func fetchGym(gymID: String) throws -> Gym?
    func fetchBouldering(brandID: String) throws -> [Bouldering] 
}

final class RealmClimbingSpaceRepository: ClimbingSpaceRepository {
    private let configuration: Realm.Configuration

    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }

    private func makeRealm() throws -> Realm { try Realm(configuration: configuration) }

    // MARK: - URL
    func fileURL() -> URL? { configuration.fileURL }

    // MARK: - Upsert All (한 트랜잭션)
    func upsertAll(brands: [Brand], gyms: [Gym], grades: [GymGrades], boulders: [Bouldering]) throws {
        let realm = try makeRealm()
        try realm.write {
            // Brand
            for brand in brands {
                realm.add(BrandObject(from: brand), update: .modified)
            }
            // Gym
            for gym in gyms {
                realm.add(GymObject(from: gym), update: .modified)
            }
            // Discipline Range (Bouldering/Lead)
            for grade in grades {
                realm.add(GymGradesObject(from: grade), update: .modified)
            }
            // Bouldering Grade Map
            for boulder in boulders {
                realm.add(BoulderingObject(from: boulder), update: .modified)
            }
        }
    }

    // MARK: - Fetch
    func fetchBrands() throws -> [Brand] {
        
        let data = try makeRealm().objects(BrandObject.self)
        let arrayData = Array(data)
        return arrayData.map { Brand(from: $0) }
    }

    func fetchAllGyms() throws -> [Gym] {
        let data = try makeRealm().objects(GymObject.self)
        let arrayData = Array(data)
        return arrayData.map { Gym(from: $0) }
    }
    
    func fetchGym(gymID: String) throws -> Gym? {
        let data = try makeRealm().object(ofType: GymObject.self, forPrimaryKey: gymID)
        return data.map { Gym(from: $0) }
    }

    
    func fetchBouldering(brandID: String) throws -> [Bouldering] {
        
        let data = try makeRealm().objects(BoulderingObject.self).filter("brandID == %@", brandID)
        return data.map { Bouldering(from: $0) }
    }
    

//    func fetchBouldering(brandID: String) throws -> [Bouldering] {
//        let data = try makeRealm().objects(BoulderingObject.self)
//        let arrayData = Array(data)
//        return arrayData.map { Bouldering(from: $0) }
//   
//    }
    
    func fetchGymGrades() throws -> [GymGrades] {
        let data = try makeRealm().objects(GymGradesObject.self)
        let arrayData = Array(data)
        return arrayData.map { GymGrades(from: $0) }
        
    }
}
