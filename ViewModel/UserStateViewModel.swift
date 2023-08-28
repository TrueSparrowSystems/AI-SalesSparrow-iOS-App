//
//  UserStateViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import Foundation

// A struct that represents the meta data of the logout api
struct LogoutStruct: Codable {}

// A struct that represents the meta data of the disconnect user API
struct DisconnectUserStruct: Codable {}

// A struct that represents the meta data of the current user API
struct CurrentUserRespStruct: Codable {
    var current_user: CurrentUserStruct
}
// A struct that represents the meta data of the current user
struct CurrentUserStruct: Codable{
    var id: String
    var name: String
    var email: String
}

// A class that represents the view model of the user states
class UserStateViewModel: ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var isLogOutInProgress = false
    @Published var isDisconnectInProgress = false
    @Published var currentUser = CurrentUserStruct(id: "", name: "", email: "")
    @Published var isAppLaunchInProgress = true
    var apiService = DependencyContainer.shared.apiService
    
    static let shared = UserStateViewModel()
    
    private init(){}
    
    // A function that sets user logged in.
    func setLoggedInUser(currentUser: CurrentUserStruct) {
        self.currentUser = currentUser
        self.isUserLoggedIn = true
    }
    
    // A function to logout user.
    func logOut()  {
        guard !self.isLogOutInProgress else {return}
        
        DispatchQueue.main.async {
            self.isLogOutInProgress = true
            
            self.apiService.post(type: LogoutStruct.self, endpoint: "/v1/auth/logout"){
                [weak self]  result, statusCode in
                
                DispatchQueue.main.async {
                    self?.isLogOutInProgress = false
                    self?.isUserLoggedIn = false
                    self?.currentUser = CurrentUserStruct(id: "", name: "", email: "")
                    HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                    
                }
                
            }
        }
    }
    
    // A function to fetch currently logged in user.
    func getCurrentUser() {
        DispatchQueue.main.async {
            self.apiService.get(type: CurrentUserRespStruct.self, endpoint: "/v1/users/current"){
                [weak self]  result, statusCode in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        self?.setLoggedInUser(currentUser: results.current_user)
                        
                    case .failure(let error):
                        print("error loading data in getCurrentUser: \(error)")
                    }
                    self?.isAppLaunchInProgress = false
                }
            }
        }
    }
    
    // A function to disconnect salesforce and logout user.
    func disconnectUser()  {
        guard !self.isDisconnectInProgress else {return}
        
        DispatchQueue.main.async {
            self.isDisconnectInProgress = true
            
            self.apiService.post(type: DisconnectUserStruct.self, endpoint: "/v1/auth/disconnect"){
                [weak self]  result, statusCode in
                
                DispatchQueue.main.async {
                    HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                    self.isDisconnectInProgress = false
                    self.currentUser = CurrentUserStruct(id: "", name: "", email: "")
                    self.isUserLoggedIn = false
                }
            }
        }
    }
    
}
