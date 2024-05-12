//
//  KakaoEndPoint.swift
//  LocationExercise
//
//  Created by kangho lee on 5/9/24.
//

import Foundation

protocol EndPoint {
  
  var baseURL: String { get }
  var version: String { get }
  var path: String { get }
  var headers: [String: String] { get }
  var method: HTTPMethod { get }
  var parameters: [String: Any]? { get }
  var encoding: ParameterEncoding { get }
  
  func makeRequest() -> URLRequest
}

enum ParameterEncoding {
  case query
  case jsonBody
}

extension EndPoint {
  func makeRequest() -> URLRequest {
    var components = URLComponents(string: baseURL)!
    components
    var body: Data?
    var queryItems: [URLQueryItem]?
    components.path = version + path
    switch encoding {
    case .jsonBody:
     body = encodeBodyParameters(parameters: parameters)
    case .query:
     queryItems = encodeQueryParameters(parameters: parameters)
      components.queryItems = queryItems
    }
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.httpBody = body
    
    return request
  }
  
  private func encodeBodyParameters(parameters: [String: Any]?) -> Data? {
    guard let parameters else { return nil }
    return try? JSONSerialization.data(withJSONObject: parameters)
  }
  
  private func encodeQueryParameters(parameters: [String: Any]?) -> [URLQueryItem]? {
    guard let parameters = parameters else { return nil }
    return parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

enum KakaoEndPoint: EndPoint {
  case searchAddress(address: String)
  case searchPOI(longitude: Double, latitude: Double)
  
  var baseURL: String {
    return "https://dapi.kakao.com"
  }
  
  var encoding: ParameterEncoding {
    switch self {
    case .searchAddress:
      return .query
    case .searchPOI:
      return .query
    }
  }
  
  var version: String {
    return "/v2"
  }
  
  var path: String {
    switch self {
    case .searchAddress:
      return "/local/search/address.json"
    case .searchPOI:
      return "/local/geo/coord2regioncode.json"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .searchAddress:
      return .get
    case .searchPOI:
      return .get
    }
  }
  
  var headers: [String: String] {
    return ["Authorization": "KakaoAK \(Bundle.kakaoAPIKey)"]
  }
  
  var parameters: [String: Any]? {
    switch self {
    case .searchAddress(let address):
      return ["query": address]
    case .searchPOI(let longitude, let latitude):
      return ["x": longitude, "y": latitude]
    }
  }
}


extension Bundle {
  static var kakaoAPIKey: String {
    guard let key = Bundle.main.infoDictionary?["API_Key"] as? String else {
      fatalError("API Key is not found")
    }
    return key
  }
}
