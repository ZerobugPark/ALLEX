//
//  NetworkManger.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import UIKit

final class NetworkManger: GoogleSheetRepository {

    
    static let shared = NetworkManger()
    
    private let decoder: JSONDecoder
    
    private init() {
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchGoogleData() async throws -> [GoogleSheetData] {
        let response = try await fetchAsyncLet()
        
        return response
    }
    
    
    private func fetchAsyncAwait(api: GoogleSheetRequest) async throws -> GoogleSheetResponse  {
                
        guard let request = api.asURLRequest() else {
            let msg = "Invalid URL address."
            throw NetworkError.invalidRequest(message: msg)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            
                let decodedErrorData = try decoder.decode(IntegrationErrorResponse.self, from: data)
                throw NetworkError.from(decodedErrorData.error.code, message: decodedErrorData.error.message)
                
            }
        
            let decodedData = try decoder.decode(GoogleSheetResponse.self, from: data)
            return decodedData
            
        } catch {
            throw error
        }
    }
    
    

    private func fetchAsyncLet() async throws -> [GoogleSheetData] {
        async let brand = NetworkManger.shared.fetchAsyncAwait(api: .brand).transform()
        async let gym = NetworkManger.shared.fetchAsyncAwait(api: .gym).transform()
        async let grade = NetworkManger.shared.fetchAsyncAwait(api: .gymGrades).transform()
        async let route = NetworkManger.shared.fetchAsyncAwait(api: .boulderingRoutes).transform()

        do {
            return try await [brand, gym, grade, route]
        } catch {
            let results = await [try? brand, try? gym, try? grade, try? route]
            
            let validResults = results.compactMap { $0 }
            if validResults.isEmpty {
                throw error
            }
            return validResults
        }
        
    }
    
    
}


