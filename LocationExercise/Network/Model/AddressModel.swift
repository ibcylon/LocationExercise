//
//  AddressModel.swift
//  LocationExercise
//
//  Created by kangho lee on 5/11/24.
//

import Foundation

struct AddressModel: CustomStringConvertible {
  let lattitude: Double
  let longitude: Double
  let code: String
  let addressName: String
  
  var description: String {
    return "Address: \(addressName), Code: \(code), Lattitude: \(lattitude), Longitude: \(longitude)"
  }
}
