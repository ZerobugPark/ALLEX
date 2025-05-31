//
//  ClimbingRecordQuery.swift
//  ALLEX
//
//  Created by youngkyun park on 5/7/25.
//

import Foundation
import RealmSwift

struct ClimbingRecordQuery {
    var objectId: ObjectId
    var date: Date
    
    // 향후 확장성을 고려해서, 하나만 있어도 조회가 가능하도록 구현
    init(objectId: ObjectId = ObjectId(), date: Date = Date()) {
        self.objectId = objectId
        self.date = date
    }
}
