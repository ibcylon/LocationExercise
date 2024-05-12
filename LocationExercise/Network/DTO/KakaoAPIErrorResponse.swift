//
//  KakaoAPIErrorResponse.swift
//  LocationExercise
//
//  Created by kangho lee on 5/11/24.
//

import Foundation

struct KakaoAPIErrorResponse: Codable {
  let code: Int
  let message: String
  
  private enum CodingKeys: String, CodingKey {
    case code
    case message = "msg"
  }
}
