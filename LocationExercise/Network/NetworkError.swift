//
//  NetworkError.swift
//  LocationExercise
//
//  Created by kangho lee on 5/11/24.
//

import Foundation

enum NetworkError: Error {
  case unknown
  case invalidURL
  case errorResponse(message: String)
  case decodingError
  case errorResponseDecodingError
  
  var message: String {
    switch self {
    case .unknown:
      return "Unknown Error"
    case .invalidURL:
      return "Invalid URL"
    case .errorResponse(let message):
      return message
    case .decodingError:
      return "Decoding Error"
    case .errorResponseDecodingError:
      return "Error Response Decoding Error"
    }
  }
}
