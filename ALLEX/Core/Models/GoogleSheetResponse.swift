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
enum ErrorCode: Error {
    case badRequest(statusCode: Int, message: String)
    case unAuthenticated(statusCode: Int, message: String)
    case permissionDenied(statusCode: Int, message: String)
    case notFound(statusCode: Int, message: String)
    case aborted(statusCode: Int, message: String)
    case internalError(statusCode: Int, message: String)
    case unImplemented(statusCode: Int, message: String)
    case unAvailable(statusCode: Int, message: String)
    case unknown(statusCode: Int, message: String)
    
    
    var localizedDescription: String {
        switch self {
        case .badRequest(_, let message):
            return message + "123213"
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
        }
    }

    
}


class ImageNetworkManager {
    
    static let shared = ImageNetworkManager()
    
    private init() { }
    
    static let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1QYRpwQkWBLmPcm5I7LjY4msekWvEwuqip2DzZh35X60/values/Gyms/?key=AIzaSyBDzXwdODvnAzYYSXQRwaK9s41y9I38Dwsㅁㅁ")!
    
    
    func fetchAsycnAwait() async throws -> GoogleSheetResponse  { // 오로지 성공 데이터
        let request = URLRequest(url: ImageNetworkManager.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // ⬅️ 백엔드 데이터 형식 대비
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                
                
                let decodedErrorData = try decoder.decode(IntegrationErrorResponse.self, from: data)
                
                switch decodedErrorData.error.code {
                case 400:
                    throw ErrorCode.badRequest(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 401:
                    throw ErrorCode.unAuthenticated(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 403:
                    throw ErrorCode.permissionDenied(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 404:
                    throw ErrorCode.notFound(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 409:
                    throw ErrorCode.aborted(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 500:
                    throw ErrorCode.internalError(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 501:
                    throw ErrorCode.unImplemented(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                case 503:
                    throw ErrorCode.unAvailable(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                default:
                    throw ErrorCode.unknown(statusCode: decodedErrorData.error.code, message: decodedErrorData.error.message)
                    
                }
            }
                
                let decodedData = try decoder.decode(GoogleSheetResponse.self, from: data)
     
                return decodedData
            } catch {
          // print("❌ 네트워크 요청 실패: \(error.localizedDescription)")
           throw error
       }
            
          
            
 
        
        
    }
}
