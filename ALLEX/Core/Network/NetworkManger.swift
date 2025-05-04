//
//  NetworkManger.swift
//  ALLEX
//
//  Created by youngkyun park on 3/28/25.
//

import UIKit

import RxCocoa
import RxSwift

final class NetworkManger: GoogleSheetRepository {
    
    
    static let shared = NetworkManger()
    
    private let decoder: JSONDecoder
    
    private init() {
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    
    
    func callRequest() -> Single<Result<[GoogleSheetData], NetworkError>> {
        
        return Single<Result<[GoogleSheetData],NetworkError>>.create { [weak self] value in
          
            guard let self = self else {
                value(.success(.failure(.unknown(statusCode: 0, message: "Instance has been deallocated"))))
                return Disposables.create()
            }
            
            Task {
                do {
                    async let brand = self.fetchAsyncAwait(api: .brand).transform()
                    async let gym = self.fetchAsyncAwait(api: .gym).transform()
                    async let grade = self.fetchAsyncAwait(api: .gymGrades).transform()
                    async let route = self.fetchAsyncAwait(api: .boulderingRoutes).transform()
                    
                    let results = try await [brand, gym, grade, route]
                    
                    value(.success(.success(results)))
                    
                } catch let error as NetworkError {
                    
                    let results = await [
                        try? self.fetchAsyncAwait(api: .brand).transform(),
                        try? self.fetchAsyncAwait(api: .gym).transform(),
                        try? self.fetchAsyncAwait(api: .gymGrades).transform(),
                        try? self.fetchAsyncAwait(api: .boulderingRoutes).transform()
                    ]
                    
                    let validResults = results.compactMap { $0 }
                    
                    if validResults.isEmpty {
                        value(.success(.failure(error)))
                    } else {
                        value(.success(.success(validResults)))
                    } 
                    
                }  catch {
                    // 예상치 못한 에러 처리
                    value(.success(.failure(.unknown(statusCode: 0, message: error.localizedDescription))))
                }
            }
            
            
            
            return Disposables.create()
        }
        

    }
    
    
    // MARK: 이미지 로드 (Kingfisher로 대체)
//    func fetchAsycnAwait(url: String) async throws -> UIImage { // 오로지 성공 데이터
//        
//        let convertURL = (convertGoogleDriveURLToDownloadLink(url))!
//        let request = URLRequest(url: URL(string: convertURL)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 1000)
//        
//        let (data, response) =  try await URLSession.shared.data(for: request)
//        
//        
//        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            throw NetworkError.unknown(statusCode: 0, message: "이미지 통신 실패")
//        }
//        
//        guard let image = UIImage(data: data) else {
//            throw NetworkError.unknown(statusCode: 0, message: "이미지 데이터 로드 실패")
//        }
//        
//        return image
//        
//        
//    }
    
    func convertGoogleDriveURLToDownloadLink(_ url: String) -> String? {
        let pattern = #"drive\.google\.com\/(?:file\/d\/|open\?id=)([a-zA-Z0-9_-]+)"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            print("정규식 생성 실패")
            return nil
        }
        
        let nsRange = NSRange(url.startIndex..<url.endIndex, in: url)
        
        guard let match = regex.firstMatch(in: url, options: [], range: nsRange) else {
            print("구글 드라이브 파일 ID를 찾을 수 없음")
            return nil
        }
        
        guard let range = Range(match.range(at: 1), in: url) else {
            print("파일 ID 추출 실패")
            return nil
        }
        
        let fileID = String(url[range])
        let downloadURL = "https://drive.google.com/uc?id=\(fileID)"
        
        return downloadURL
    }
}


