//
//  ToastViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 09/08/23.
//

import Foundation
import SwiftUI

class ToastViewModel: ObservableObject {
    @Published var toast: Toast? = nil
    static let shared = ToastViewModel()
    
    private init(){}
    
    func showToast(_toast: Toast){
        self.toast = _toast
    }
    
}
