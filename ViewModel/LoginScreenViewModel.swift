//
//  LoginScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//


import Foundation

// A struct that represents the meta data of the list
struct LoginStruct: Codable {
    var url: String
}

// A class that represents the view model of the LoginScreen
class LoginScreenViewModel: ObservableObject {
    @Published var loginData = LoginStruct(url: "")
    @Published var isfetchUrlInProgress = false
    @Published var isLoginInProgress = false
    var apiService = DependencyContainer.shared.apiService

    func fetchSalesforceConnectUrl(onSuccess : @escaping(String)-> Void, onFailure : @escaping()-> Void) {
        self.loginData.url = "https://test.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9ZUGg10Hh227MLPM3wiLMlm14912oDqdl4sBAgV3rUL880XmgYEXzKDYkuelHPJaxNtcjpXvY0bMjUSZZ&redirect_uri=\(Environments.shared.vars["redirect_uri"] ?? "")"

        guard !self.isfetchUrlInProgress else {return}
        guard self.loginData.url == "" else {
            onSuccess(self.loginData.url)
            return
        }
        self.isfetchUrlInProgress = true
        let params: [String: Any] = ["redirect_uri": Environments.shared.vars["redirect_uri"] ?? ""]
        apiService.get(type: LoginStruct.self, endpoint: "/v1/auth/salesforce/redirect-url", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.loginData.url = results.url
                    print("-----------------self?.loginData.url--\(self?.loginData.url)")
                    onSuccess(results.url)
                    self?.isfetchUrlInProgress = false
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    onFailure()
                    self?.isfetchUrlInProgress = false
                }
            }

        }
    }

    func authenticateUser(authCode: String?, onSuccess : @escaping()-> Void, onFailure : @escaping()-> Void){

        guard !self.isLoginInProgress else {
            return
        }
        //TODO: Remove this once the login api is implemented
        onSuccess()
        self.isLoginInProgress = false

        self.isLoginInProgress = true

        apiService.get(type: LoginStruct.self, endpoint: ""){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    onSuccess()
                    self?.isLoginInProgress = false
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    onFailure()
                    self?.isLoginInProgress = false
                }
            }

        }
    }
}
