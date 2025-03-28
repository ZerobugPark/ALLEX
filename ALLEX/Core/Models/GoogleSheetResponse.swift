//
//  GoogleSheetResponse.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import Foundation

// MARK: - Google Sheet Response
struct GoogleSheetResponse: Decodable {
    let values: [[String]]
    
    func transform() -> GoogleSheetData {
        return GoogleSheetData(values: values)
    }
}

// MARK: - DTO (Data Transfer Object)
struct GoogleSheetData {
    let values: [[String]]
    // Note: 향후 확장 가능성 있음
    
}


// MARK: - Google Application Integration Error
struct IntegrationErrorResponse: Decodable {
    let error: ErrorMessages
}

// MARK: - Error
struct ErrorMessages: Decodable {
    let code: Int
    let message, status: String
}

// MARK: - ErroCode Definition
enum NetworkError: Error {
    case badRequest(statusCode: Int, message: String)
    case unAuthenticated(statusCode: Int, message: String)
    case permissionDenied(statusCode: Int, message: String)
    case notFound(statusCode: Int, message: String)
    case aborted(statusCode: Int, message: String)
    case internalError(statusCode: Int, message: String)
    case unImplemented(statusCode: Int, message: String)
    case unAvailable(statusCode: Int, message: String)
    case unknown(statusCode: Int, message: String)
    case invalidRequest(message: String)
    
    
    var localizedDescription: String {
        switch self {
        case .badRequest(_, let message):
            return message
        case .unAuthenticated(_, let message):
            return message
        case .permissionDenied(_, let message):
            return message
        case .notFound(_, let message):
            return message
        case .aborted(_, let message):
            return message
        case .internalError(_, let message):
            return message
        case .unImplemented(_, let message):
            return message
        case .unAvailable(_, let message):
            return message
        case .unknown(_, let message):
            return message
        case .invalidRequest(let message):
            return message
        }
    }

    
}

extension NetworkError {
    static func from(_ code: Int, message: String) -> NetworkError {
        switch code {
        case 400:
            return .badRequest(statusCode: code, message: message)
        case 401:
            return .unAuthenticated(statusCode: code, message: message)
        case 403:
            return .permissionDenied(statusCode: code, message: message)
        case 404:
            return .notFound(statusCode: code, message: message)
        case 409:
            return .aborted(statusCode: code, message: message)
        case 500:
            return .internalError(statusCode: code, message: message)
        case 501:
            return .unImplemented(statusCode: code, message: message)
        case 503:
            return .unAvailable(statusCode: code, message: message)
        default:
            return .unknown(statusCode: code, message: message)
   
        }
    }
}

