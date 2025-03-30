//
//  GoogleSheetDTO.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import Foundation
import RxSwift

protocol GoogleSheetRepository {
    //func fetchGoogleData() async throws -> [GoogleSheetData]
    func callRequest() -> Single<Result<[GoogleSheetData], NetworkError>>
    
}
