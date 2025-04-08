//
//  DetailSpace.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import UIKit
import RxDataSources

// MARK: - Models
struct FacilityInfo {
    let facility: String
}

struct BoulderingGrade {
    let difficulty: String
    let color: String
}

enum GymInfoSectionItem {
    case headerItem(title: String, address: String, insta: String, logoImage: String)
    case facilityItem(FacilityInfo)
    case boulderingGradeItem(BoulderingGrade)
    case footerItem(String)
}

// 섹션 타입 (섹션의 정보를 나타냄)
enum GymInfoSection {
    case header(title: String)
    case facilityInfo(title: String)
    case boulderingGrade(title: String)
    case footer
}

// SectionModelType 프로토콜을 준수하는 섹션 모델
struct GymInfoSectionModel {
    var section: GymInfoSection
    var items: [GymInfoSectionItem]
}

// RxDataSources의 SectionModelType 프로토콜 준수
extension GymInfoSectionModel: SectionModelType {
  
    typealias Item = GymInfoSectionItem
    

    
    init(original: GymInfoSectionModel, items: [GymInfoSectionItem]) {
        self = GymInfoSectionModel(section: original.section, items: items)
    }
}

