//
//  DetailSpaceViewModel.swift
//  ALLEX
//
//  Created by youngkyun park on 4/8/25.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift


final class DetailSpaceViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let sections: Driver<[GymInfoSectionModel]>
    }
    
    
    private var resultData: [Gym] = []
    
    var disposeBag = DisposeBag()
    
    private var sharedData: SharedDataModel
    private var sectionsData: [GymInfoSectionModel] = []
    
    init(_ sharedData: SharedDataModel, _ gymID: String) {
        self.sharedData = sharedData
        
        sectionsData = formatData(gymID)
    }
    
    
    
    func transform(input: Input) -> Output {
        
        let sections = BehaviorRelay<[GymInfoSectionModel]>(value: sectionsData)
        
        return Output(sections: sections.asDriver(onErrorJustReturn: []))
    }
    
    
    deinit {
        print(String(describing: self) + "Deinit")
    }
}

extension DetailSpaceViewModel {
    
    private func formatData(_ id: String) -> [GymInfoSectionModel] {
        let gymInfo: Gym = sharedData.getData(for: Gym.self)!.filter { $0.gymID == id }.first!
            
        
        // 헤더 섹션
        let headerSection: GymInfoSectionModel
        
    
        if Locale.isEnglish {
            headerSection = GymInfoSectionModel(
                section: .header(title: "Climbing Info"),
                items: [.headerItem(title: gymInfo.nameEn, address: gymInfo.addressEn, insta: gymInfo.instaID, logoImage: gymInfo.imageURL)]
            )
        } else {
            headerSection = GymInfoSectionModel(
                section: .header(title: "기본 정보"),
                items: [.headerItem(title: gymInfo.nameKo, address: gymInfo.addressEn, insta: gymInfo.instaID, logoImage: gymInfo.imageURL)]
            )
        }
        
        
        // 난이도 섹션
        let brandInfo: [Bouldering] = sharedData.getData(for: Bouldering.self)!.filter { $0.brandID == gymInfo.brandID }
        let grades = brandInfo.map { BoulderingGrade(difficulty: $0.difficulty, color: $0.color) }
        let gradeItems = grades.map { GymInfoSectionItem.boulderingGradeItem($0) }
        let boulderingGradeSection = GymInfoSectionModel(
            section: .boulderingGrade(title: LocalizedKey.Gym_Info_Grade.rawValue.localized(with: "")),
            items: gradeItems
        )
        
        
        
        // 시설 정보 섹션
        let facilities = gymInfo.facilities.map { FacilityInfo(facility: $0) }
        let facilityItems = facilities.map { GymInfoSectionItem.facilityItem($0) }
        let facilitySection = GymInfoSectionModel(
            section: .facilityInfo(title:  LocalizedKey.Gym_Info_facility.rawValue.localized(with: "")),
            items: facilityItems
        )
        

        // 푸터 섹션
        let footerSection = GymInfoSectionModel(
            section: .footer,
            items: [.footerItem(LocalizedKey.Gym_Info_request_modify.rawValue.localized(with: ""))]
        )
        
        // 모든 섹션 반환
        return [headerSection, boulderingGradeSection, facilitySection, footerSection]
    }
    
    
}
