//
//  LoginScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

// A struct that represents the meta data of the redirect url API
struct RedirectUrlStruct: Codable {
    var url: String
}

// A struct that represents the meta data of the salesforce connect API
struct SalesforceConnectStruct: Codable {
    var current_user: CurrentUserStruct
}

// A class that represents the view model of the LoginScreen
class LoginScreenViewModel: ObservableObject {
    @Published var loginData = RedirectUrlStruct(url: "")
    @Published var isLoginInProgress = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function to get salesforce connect url from BE.
    func fetchSalesforceConnectUrl(onSuccess: @escaping(String) -> Void, onFailure: @escaping() -> Void) {
        guard !self.isLoginInProgress else {return}
        guard self.loginData.url.isEmpty else {
            onSuccess(self.loginData.url)
            return
        }
        self.isLoginInProgress = true
        let params: [String: Any] = ["redirect_uri": Environments.shared.vars["redirect_uri"] ?? ""]
        apiService.get(type: RedirectUrlStruct.self, endpoint: "/v1/auth/salesforce/redirect-url", params: params) {
            [weak self]  result, _ in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.loginData.url = results.url
                    onSuccess(results.url)
                    self?.isLoginInProgress = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure()
                    self?.isLoginInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
    
    // A function to login user by calling BE API.
    func salesforceConnect(authCode: String?, onSuccess: @escaping() -> Void, onFailure: @escaping() -> Void) {
        
        guard !self.isLoginInProgress else {
            return
        }
        self.isLoginInProgress = true
        
        let params: [String: Any] = [
            "code": authCode ?? "",
            "redirect_uri": Environments.shared.vars["redirect_uri"] ?? ""
        ]
        apiService.post(type: SalesforceConnectStruct.self, endpoint: "/v1/auth/salesforce/connect", params: params) {
            [weak self]  result, _ in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    UserStateViewModel.shared.setLoggedInUser(currentUser: results.current_user)
                    onSuccess()
                    self?.isLoginInProgress = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure()
                    self?.isLoginInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
}
