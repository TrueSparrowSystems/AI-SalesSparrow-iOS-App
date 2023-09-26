//
//  SafariWebViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 21/09/23.
//

import Foundation
import SwiftUI

// A class that represents the view model of the toast.
class SafariWebViewModel: ObservableObject {
    @Published var isWebViewVisible: Bool = false
    @Published var url: String = ""
    static let shared = SafariWebViewModel()
    
    private init() {}
    
    func showWebView(_url: String) {
        self.isWebViewVisible = true
        self.url = _url
    }
    
    func hideWebView() {
        self.isWebViewVisible = false
        self.url = ""
    }
    
}
