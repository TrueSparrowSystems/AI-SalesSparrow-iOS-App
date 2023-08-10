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
    
    static let shared = UserStateViewModel()
    
    private init(){}
    
    func setLoggedInUser(currentUser: CurrentUserStruct) {
        print("setting logged in user \(currentUser)")
        
        self.currentUser = currentUser
        self.isUserLoggedIn = true
    }
    
    func logOut()  {
        guard !self.isLogOutInProgress else {return}
        // TODO: remove this line once API is available
        self.isUserLoggedIn = false
        DispatchQueue.main.async {
            self.isLogOutInProgress = true
            
            ApiService().post(type: LogoutStruct.self, endpoint: ""){
                [weak self]  result, statusCode in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.isUserLoggedIn = false
                        self?.isLogOutInProgress = false
                        
                        
                    case .failure(let error):
                        print("error loading data in logout: \(error)")
                        self?.isLogOutInProgress = false
                    }
                }
                
            }
        }
    }
    
    func getCurrentUser() {
        DispatchQueue.main.async {
            ApiService().get(type: CurrentUserRespStruct.self, endpoint: "/v1/users/current"){
                [weak self]  result, statusCode in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        self?.setLoggedInUser(currentUser: results.current_user)
                                                
                    case .failure(let error):
                        print("error loading data in getCurrentUser: \(error)")
                    }
                }
            }
        }
    }
}
