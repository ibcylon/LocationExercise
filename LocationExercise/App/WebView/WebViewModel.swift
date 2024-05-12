//
//  WebViewModel.swift
//  LocationExercise
//
//  Created by kangho lee on 4/29/24.
//

import Foundation
import Combine

class WebViewModel: ObservableObject {
  private let service: LocationServiceType
  private var cancellables = Set<AnyCancellable>()
  
  @Published var isShowingWebView = false
  @Published var addressValue = ""
  
  init(locationService: LocationServiceType) {
    self.service = locationService
    
    service.publisher
      .receive(on: RunLoop.main)
      .sink { [weak self] location in
        self?.addressValue = location
      }
      .store(in: &cancellables)
  }
  
  @MainActor
  func requestLocation() {
    service.fetchLocation()
  }
  
  func requestFromKakaoAPIThroughDaumAPI() {
    service
  }
  
  func requestFromKakaoAPIThroughCoreLocation() {
    
  }
}
