//
//  LoginScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//


import Foundation
import SwiftUI

// A struct that represents the meta data of the list
struct LoginStruct: Codable {
    var salesforce_connect_url: String
}

// A class that represents the view model of the LoginScreen
class LoginScreenViewModel: ObservableObject {
    @Published var loginData = LoginStruct(salesforce_connect_url: "")
    @Published var isfetchUrlInProgress = false
    @Published var isLoginInProgress = false
    
    func fetchSalesforceConnectUrl(onSuccess : @escaping(String)-> Void, onFailure : @escaping()-> Void) {
        self.loginData.salesforce_connect_url = "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZUGg10Hh227MLPM3wiLMlm14912oDqdl4sBAgV3rUL880XmgYEXzKDYkuelHPJaxNtcjpXvY0bMjUSZZ&redirect_uri=salessparrow://oauth/success"
        
        guard !self.isfetchUrlInProgress else {return}
        guard self.loginData.salesforce_connect_url == "" else {
            onSuccess(self.loginData.salesforce_connect_url)
            return
        }
        self.isfetchUrlInProgress = true
        ApiService().get(type: LoginStruct.self, endpoint: ""){
            [weak self]  result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.loginData.salesforce_connect_url = results.salesforce_connect_url
                    onSuccess(results.salesforce_connect_url)
                    self?.isfetchUrlInProgress = false
                }
                
            case .failure(let error):
                print("error loading data: \(error)")
                onFailure()
                self?.isfetchUrlInProgress = false
            }
            
        }
    }
    
    func authenticateUser(authCode: String?, onSuccess : @escaping()-> Void, onFailure : @escaping()-> Void){
        
        guard !self.isLoginInProgress else {return}
        self.isLoginInProgress = true
        onSuccess()
        self.isLoginInProgress = false
        return
        ApiService().get(type: LoginStruct.self, endpoint: ""){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    onSuccess()
                    self?.isLoginInProgress = false
                }
                
            case .failure(let error):
                print("error loading data: \(error)")
                onFailure()
                self?.isLoginInProgress = false
            }
            
        }
    }
}
