//
//  AlertViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 24/08/23.
//

import SwiftUI

struct Alert {
    var title: String
    var message: Text
    var cancelText: String = "Cancel"
    var submitButtonIdentifier: String = "alert_submit_button"
    var submitText: String
    var onSubmitPress: () -> Void
}


// A class that represents the view model of the toast.
class AlertViewModel: ObservableObject {
    @Published var isAlertVisible = false
    static let shared = AlertViewModel()
    var alert : Alert?
    
    private init(){}
    
    func showAlert(_alert: Alert){
        self.isAlertVisible = true
        self.alert = _alert
    }
    
    func dismissAlert(){
        self.isAlertVisible = false
        self.alert = nil
    }
    
}
