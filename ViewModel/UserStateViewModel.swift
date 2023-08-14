//
//  UserStateViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import Foundation

struct LogoutStruct: Codable {}
struct CurrentUserRespStruct: Codable {
    var current_user: CurrentUserStruct
}
struct CurrentUserStruct: Codable{
    var id: String
    var name: String
    var email: String
}

class UserStateViewModel: ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var isLogOutInProgress = false
    @Published var currentUser = CurrentUserStruct(id: "", name: "", email: "")
    @Published var isAppLaunchInProgress = true
    var apiService = DependencyContainer.shared.apiService
    
    static let shared = UserStateViewModel()
    
    private init(){}
    
    func setLoggedInUser(currentUser: CurrentUserStruct) {
        self.currentUser = currentUser
        self.isUserLoggedIn = true
    }
    
    func logOut()  {
        guard !self.isLogOutInProgress else {return}
        
        DispatchQueue.main.async {
            self.isLogOutInProgress = true
            
            self.apiService.post(type: LogoutStruct.self, endpoint: "/v1/auth/logout"){
                [weak self]  result, statusCode in
                
                DispatchQueue.main.async {
                    self?.isLogOutInProgress = false
                    self?.isUserLoggedIn = false
                    HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                    
                }
                
            }
        }
    }
    
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
}
