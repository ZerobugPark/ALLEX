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


 
