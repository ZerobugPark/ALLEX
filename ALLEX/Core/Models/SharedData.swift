//
//  SharedData.swift
//  ALLEX
//
//  Created by youngkyun park on 3/30/25.
//

import Foundation

final class SharedDataModel {
    private var brandData : [Brand] = []
    private var gymData: [Gym] = []
    private var gymGradeData: [GymGrades] = []
    private var boulderingData: [Bouldering] = []
    // 제네릭 메서드를 사용하여 데이터를 업데이트
    
    func updateData<T: Mappable>(data: [T], for type: T.Type) {
        switch type {
        case is Brand.Type:
            brandData = data as! [Brand]
        case is Gym.Type:
            gymData = data as! [Gym]
        case is GymGrades.Type:
            gymGradeData = data as! [GymGrades]
        case is Bouldering.Type:
            boulderingData = data as! [Bouldering]
        default:
            print("Unknown")
            
        }
    }
    
    func getData<T: Mappable>(for type: T.Type) -> [T]? {
        switch type {
        case is Brand.Type:
            return brandData as? [T]
        case is Gym.Type:
            return gymData as? [T]
        case is GymGrades.Type:
            return gymGradeData as? [T]
        case is Bouldering.Type:
            return boulderingData as? [T]
        default:
            return nil
            
        }
    }
  
  
}
