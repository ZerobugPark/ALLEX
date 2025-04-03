//
//  ClimbingResultRepository.swift
//  ALLEX
//
//  Created by youngkyun park on 4/4/25.
//

import Foundation

protocol ClimbingResultRepository: Repository where T == ClimbingResultTable {

}

final class RealmClimbingResultRepository: RealmRepository<ClimbingResultTable>, ClimbingResultRepository {
    

    
    
    
}
