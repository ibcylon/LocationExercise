//
//  ContentView.swift
//  LocationExercise
//
//  Created by kangho lee on 4/28/24.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = WebViewModel(locationService: LocationService())
  
  var body: some View {
    VStack {
      Label(viewModel.addressValue, systemImage: "location.fill")
      
      Button("Fetch By Core Location") {
        viewModel.requestLocation()
      }
      Button("Open Daum API") {
        viewModel.isShowingWebView.toggle()
      }.sheet(isPresented: $viewModel.isShowingWebView) {
        WebView(url: "https://ibcylon.github.io/DaumAPI/", viewModel: viewModel)
      }
      Button("Fetch By KaKaoAPI using address through DaumAPI") {
        viewModel.requestFromKakaoAPIThroughDaumAPI()
      }
      
      Button("Fetch By KakaoAPI using coordinate2D through CoreLocation") {
        viewModel.requestFromKakaoAPIThroughCoreLocation()
      }
    }
    .padding()
  }
}
#Preview {
  ContentView()
}
