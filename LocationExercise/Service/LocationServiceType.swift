//
//  LocationServiceType.swift
//  LocationExercise
//
//  Created by kangho lee on 4/28/24.
//

import Foundation
import Combine
import CoreLocation

protocol LocationServiceType {
  func fetchLocation()
  func isValidLocation() -> Bool
  var publisher: PassthroughSubject<String, Never> { get }
}
