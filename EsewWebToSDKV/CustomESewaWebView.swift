//
//  CustomWebView.swift
//  EsewWebToSDK
//
//  Created by Nabraj Khadka on 08/09/2025.
//
import SwiftUI
import WebKit
import CryptoKit
import Foundation

// MARK: - Advanced WebView with Navigation Delegate (Fixed)
struct CustomESewaWebView: UIViewRepresentable {
    let postData: [String: String]
    let url: URL
    @Binding var isLoading: Bool
    @Binding var currentURL: String?
    var onSuccess: ((String) -> Void)?
    var onFailure: ((String) -> Void)?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        // Create and load POST request ONLY in makeUIView
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let formData = postData.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }.joined(separator: "&")
        
        request.httpBody = formData.data(using: .utf8)
        
        print("eSewa POST Data: \(String(data: formData.data(using: .utf8) ?? Data(), encoding: .utf8) ?? "")")
        
        // Load only once during creation
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Empty - do not reload here to prevent infinite requests
        // This method is called on every SwiftUI update
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: CustomESewaWebView
        
        init(_ parent: CustomESewaWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.currentURL = webView.url?.absoluteString
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let url = navigationAction.request.url {
                let urlString = url.absoluteString
                
                DispatchQueue.main.async {
                    if urlString.contains("success") {
                        self.parent.onSuccess?(urlString)
                        print("Payment Success: \(urlString)")
                    } else if urlString.contains("failure") {
                        self.parent.onFailure?(urlString)
                        print("Payment Failed: \(urlString)")
                    }
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
            print("WebView navigation failed: \(error.localizedDescription)")
        }
    }
}
