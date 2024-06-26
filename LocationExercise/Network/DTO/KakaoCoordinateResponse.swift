//
//  KakaoCoordinateResponse.swift
//  LocationExercise
//
//  Created by kangho lee on 5/11/24.
//

import Foundation

struct KakaoCoordinateResponse: Codable {
  let documents: [Document]
  
  struct Document: Codable {
    let addressName: String
    let region1depthName, region2depthName, region3depthName: String
    let regionType: String
    let code: String
    let x, y: Double
    
    private enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1depthName = "region_1depth_name"
      case region2depthName = "region_2depth_name"
      case region3depthName = "region_3depth_name"
      case regionType = "region_type"
      case code
      case x, y
    }
    
    enum RegionType: String, Codable {
      case admin = "H"
      case law = "B"
      
      private enum CodingKeys: String, CodingKey {
        case admin = "H"
        case law = "B"
      }
    }
  }
}

extension KakaoCoordinateResponse {
  func toDomain() -> AddressModel? {
    let lawAddress = documents.first { docmuent in
      docmuent.regionType == "B"
    }
    
    guard let document = lawAddress else { return nil }
    
    let addressName = document.addressName
    
    return AddressModel(lattitude: document.y, longitude: document.x, code: document.code, addressName: addressName)
  }
}
