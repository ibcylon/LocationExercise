//
//  HTTPClient.swift
//  LocationExercise
//
//  Created by kangho lee on 5/9/24.
//

import Foundation

protocol HTTPClient {
  func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

extension URLSession: HTTPClient {
  func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
    let (data, response) = try await self.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidURL
    }
    
    return (data, httpResponse)
  }
}
