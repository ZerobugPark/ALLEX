//
//  FacilityDesign.swift
//  ALLEX
//
//  Created by youngkyun park on 4/9/25.
//

import UIKit

extension UIImage {
    
    enum FacilityDesign: String, CaseIterable {
        case stretchingzone = "figure.strengthtraining.functional"
        case shower = "shower.fill"
        case toilet = "toilet.fill"
        case training = "figure.strengthtraining.traditional"
        case footbath = "pawprint.fill"
        case towel = "square.stack.3d.up.fill"
        case locker = "lock.fill"
           
        
        var image: UIImage? {
            return UIImage(systemName: self.rawValue)
        }
        
        static func from(_ name: String) -> FacilityDesign? {
            return FacilityDesign.allCases.first {
                $0.rawValue.caseInsensitiveCompare(name) == .orderedSame ||
                String(describing: $0).caseInsensitiveCompare(name) == .orderedSame
            }
        }
    }
    
    
    static func setSymbol(from name: String) -> UIImage? {
        let matchedFacility = FacilityDesign.from(name)
        return matchedFacility?.image
    }
    
   
}

enum Facility: String {
    case Toilet, Footbath, Shower, Locker, StretchingZone, Training, Towel
    
    func localizedName(for language: String) -> String {
        switch self {
        case .Toilet: return language == "en" ?  "Toilet" : "화장실"
        case .Footbath: return language == "en" ?  "Footbath" : "세족실"
        case .Shower: return language == "en" ? "Shower" : "샤워실"
        case .Locker: return language == "en" ? "Locker" : "라커룸"
        case .StretchingZone: return language == "en" ? "Stretching Zone" : "스트레칭 존"
        case .Training: return language == "en" ?  "Training Area" : "트레이닝 구역"
        case .Towel: return language == "en" ? "Towel Service" : "수건 제공"
        }
    }
}

