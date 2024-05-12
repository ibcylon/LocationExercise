//
//  KakaoResponse.swift
//  LocationExercise
//
//  Created by kangho lee on 5/9/24.
//

import Foundation

struct KakaoSearchResponse: Codable {
  let documents: [Document]
  
  struct Document: Codable {
    let address: Address?
    let roadAddress: RoadAddress?
    let x, y: String
    
    private enum CodingKeys: String, CodingKey {
      case address, x, y
      case roadAddress = "road_address"
    }
  }
  
  struct Address: Codable {
    let addressName: String
    let region1depthName, region2depthName, region3depthName: String
    let lawCode: String
    let x, y: String
    
    private enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1depthName = "region_1depth_name"
      case region2depthName = "region_2depth_name"
      case region3depthName = "region_3depth_name"
      case lawCode = "b_code"
      case x, y
    }
  }
  
  struct RoadAddress: Codable {
    let addressName: String
    let region1depthName, region2depthName, region3depthName: String
    let x,y: String
    
    private enum CodingKeys: String, CodingKey {
      case addressName = "address_name"
      case region1depthName = "region_1depth_name"
      case region2depthName = "region_2depth_name"
      case region3depthName = "region_3depth_name"
      case x, y
    }
  }
}

extension KakaoSearchResponse {
  func toDomain() -> AddressModel? {
    guard let document = documents.first,
          let address = document.address,
          let longitude = Double(document.x),
          let latitude = Double(document.y) else {
      return nil
    }
    
    let addressName = address.region1depthName + address.region2depthName + address.region3depthName
    
    let code = address.lawCode
    return AddressModel(lattitude: latitude, longitude: longitude, code: code, addressName: addressName)
  }
}
