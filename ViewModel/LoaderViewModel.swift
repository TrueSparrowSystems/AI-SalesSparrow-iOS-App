//
//  LoaderViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/08/23.
//

import Foundation

class LoaderViewModel: ObservableObject {
    @Published var isLoaderVisible = false
    static let shared = LoaderViewModel()
    
    private init() {}
    
    func showLoader() {
        self.isLoaderVisible = true
    }
    
    func hideLoader() {
        self.isLoaderVisible = false
    }
}
