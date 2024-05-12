//
//  LocationConverter.swift
//  LocationExercise
//
//  Created by kangho lee on 4/29/24.
//

import CoreLocation
import Foundation

protocol LocationConverterType {
  func convertLocationToAddress(location: CLLocation) async throws -> String
}

enum LocationError: Error {
  case noPlacemark
  case noLocation
}

class LocationConverter: LocationConverterType {
  private let geocoder = CLGeocoder()
  
  func convertLocationToAddress(location: CLLocation) async throws -> String {
    let placemarks = try await geocoder.reverseGeocodeLocation(location)
    
    guard
      let placemark = placemarks.last,
      let administrativeArea = placemark.administrativeArea,
      let locality = placemark.locality,
      let subLocale = placemark.subLocality
    else {
      throw LocationError.noPlacemark
    }
    
    let address = "\(administrativeArea) \(locality) \(subLocale)"
    
    return address
  }
}
