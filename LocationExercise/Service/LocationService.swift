//
//  LocationService.swift
//  LocationExercise
//
//  Created by kangho lee on 4/28/24.
//

import Foundation
import CoreLocation
import Combine

final class LocationService: NSObject, LocationServiceType {
  
  private let manager = CLLocationManager()
  private let geocoder = CLGeocoder()
  private let kakaoClient: KakaoClient
  
  var publisher = PassthroughSubject<String, Never>()
  
  init(kakaoClient: KakaoClient = KakaoClientImpl()) {
    self.kakaoClient = kakaoClient
    super.init()
    manager.delegate = self
  }
  
  func fetchLocation() {
    manager.requestWhenInUseAuthorization()
    handleStatus(manager.authorizationStatus)
  }
  
  func isValidLocation() -> Bool {
    return true
  }
  
  private func enableLocation() {
    print("Authorized")
    manager.requestLocation()
    
  }
  
  private func disableLocation() {
    print("Not Authorized")
    manager.stopUpdatingLocation()
  }
  
  func checkAuthorization() {
    handleStatus(manager.authorizationStatus)
  }
  
  private func handleStatus(_ status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
//      manager.requestWhenInUseAuthorization()
      print("not determined")
    case .restricted, .denied:
      disableLocation()
    case .authorizedAlways, .authorizedWhenInUse:
      enableLocation()
    @unknown default:
      print("unhandled case")
    }
  }
  
  private func fetchAddressFromKakaoAPI(location: CLLocation) async throws -> String {
    guard let domain = try await kakaoClient.searchFromPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude).toDomain() else {
      throw LocationError.noLocation
    }
    print(domain.description)
    return domain.addressName
  }
  
  private func convertLocationToAddress(location: CLLocation) async throws -> String {
    let placemarks = try await geocoder.reverseGeocodeLocation(location)
    
    guard
      let placemark = placemarks.last,
      let locality = placemark.locality,
      let subLocale = placemark.subLocality,
      let street = placemark.thoroughfare
    else {
      throw LocationError.noPlacemark
    }
    print("Region id: \(placemark.region?.identifier)")
    print("postal code: \(placemark.postalCode)")
    
    let address = "\(locality) \(subLocale) \(street)"
    
    return address
  }
  
  func convertAddressToLocation(address: String) async throws -> CLLocation {
    let placemarks = try await geocoder.geocodeAddressString(address)
    
    guard let placemark = placemarks.last else {
      throw LocationError.noPlacemark
    }
    
    guard let location = placemark.location else {
      throw LocationError.noLocation
    }
    
    return location
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    handleStatus(manager.authorizationStatus)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      Task {
        let address = try await self.fetchAddressFromKakaoAPI(location: location)
        publisher.send(address)
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print(error.localizedDescription)
  }
}

