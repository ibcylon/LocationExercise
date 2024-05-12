//
//  WebView.swift
//  LocationExercise
//
//  Created by kangho lee on 4/29/24.
//

import UIKit
import SwiftUI
import Combine
import WebKit

protocol WebViewDelegate {
  func didReceiveAddress(_ address: String)
}

struct WebView: UIViewRepresentable {
  enum Name: String {
    case bridge = "callBackHandler"
    case jibunAddress
  }
  
  var url: String
  @ObservedObject var viewModel: WebViewModel
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIView(context: Context) -> WKWebView {
    let preferences = WKPreferences()
    preferences.javaScriptCanOpenWindowsAutomatically = false
    
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    configuration.userContentController.add(context.coordinator, name: Name.bridge.rawValue)
    
    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    webView.allowsBackForwardNavigationGestures = false
    webView.scrollView.isScrollEnabled = true
    
    if let url = URL(string: url) {
      webView.load(URLRequest(url: url))
    }
    
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView
    var subscribe: AnyCancellable? = nil
    
    init(_ parent: WebView) {
      self.parent = parent
    }
    
    deinit {
      subscribe?.cancel()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      return decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      
    }
  }
}

extension WebView: WebViewDelegate {
  func didReceiveAddress(_ address: String) {
    viewModel.addressValue = address
    viewModel.isShowingWebView = false
  }
}

extension WebView.Coordinator: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if message.name == WebView.Name.bridge.rawValue {
      if let body = message.body as? [String: Any] {
        for pair in body {
          print(pair.key,":", pair.value as? String ?? "")
        }
        if let address = body[WebView.Name.jibunAddress.rawValue] as? String {
          var formatted = address.components(separatedBy: " ")
          var returnValue = ""
          if formatted[0] != "서울" {
            formatted.removeFirst()
          } else {
            formatted[0] = "서울시"
          }
          returnValue = formatted.prefix(3).joined(separator: " ")
          
          parent.didReceiveAddress(returnValue)
        }
      }
    }
  }
}
