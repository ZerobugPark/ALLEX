//
//  GoogleSheetDTO.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import Foundation

protocol GoogleSheetRepository {
    func fetchGoogleData() async throws -> [GoogleSheetData]
}
