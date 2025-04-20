//
//  GoogleSheetDTO.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import Foundation
import RxSwift

protocol GoogleSheetRepository {
    func callRequest() -> Single<Result<[GoogleSheetData], NetworkError>>
    
}
