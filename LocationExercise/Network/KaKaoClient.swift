//
//  KaKaoClient.swift
//  LocationExercise
//
//  Created by kangho lee on 5/9/24.
//

import Foundation

protocol KakaoClient {
  func searchFromAddress(address: String) async throws -> KakaoSearchResponse
  func searchFromPoint(longitude: Double, latitude: Double) async throws -> KakaoCoordinateResponse
}

struct KakaoClientImpl: KakaoClient {
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func searchFromAddress(address: String) async throws -> KakaoSearchResponse {
    let endPoint = KakaoEndPoint.searchAddress(address: address)
    return try await self.mapper(kakaoEndPoint: endPoint)
  }
  
  func searchFromPoint(longitude: Double, latitude: Double) async throws -> KakaoCoordinateResponse {
     let endPoint = KakaoEndPoint.searchPOI(longitude: longitude, latitude: latitude)
    return try await self.mapper(kakaoEndPoint: endPoint)
  }
  
  private func mapper<T: Decodable>(kakaoEndPoint: KakaoEndPoint) async throws -> T {
    let request = kakaoEndPoint.makeRequest()
    let (data, response) = try await self.session.perform(request: request)
    
    switch response.statusCode {
      case 200:
      guard let response = try? JSONDecoder().decode(T.self, from: data) else {
        throw NetworkError.decodingError
      }
      return response
      
      default:
      guard let errorResponse = try? JSONDecoder().decode(KakaoAPIErrorResponse.self, from: data) else {
        throw NetworkError.errorResponseDecodingError
      }
      throw NetworkError.errorResponse(message: errorResponse.message)
    }
  }
}
