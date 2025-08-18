//
//  GoogleSheetRequest.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import Foundation

enum GoogleSheetRequest {
    
    case version
    case brand
    case gym
    case gymGrades
    case boulderingRoutes
    case leadRoutes

    var endpoint: GoogleSheetEndPoint {
        switch self {
        case .version:
            return .version
        case .brand:
            return .brand
        case .gym:
            return .gym
        case .gymGrades:
            return .gymGrades
        case .boulderingRoutes:
            return .boulderingRoutes
        case .leadRoutes:
            return .leadRoutes
    
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .version, .brand, .gym, .gymGrades, .boulderingRoutes, .leadRoutes:
            return ["key": GoogleAPI.APIKey]
        }
    }
    
    func asURLRequest() -> URLRequest? {
        if let parameters = parameters, !parameters.isEmpty {
            var components = URLComponents(string: endpoint.stringURL)!
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            guard let url = components.url else { return nil }
            return makeRequest(with: url)
        } else {
            guard let url = URL(string: endpoint.stringURL) else { return nil }
            return makeRequest(with: url)
        }
    }
    
    private func makeRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        request.httpMethod = "GET"
      
      
        return request
    }
}
