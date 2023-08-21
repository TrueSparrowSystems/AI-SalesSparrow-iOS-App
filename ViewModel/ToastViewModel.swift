//
//  ToastViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 09/08/23.
//

import Foundation
import SwiftUI

// A class that represents the view model of the toast.
class ToastViewModel: ObservableObject {
    @Published var toast: Toast? = nil
    static let shared = ToastViewModel()
    
    private init(){}
    
    func showToast(_toast: Toast){
        self.toast = _toast
    }
    
}
