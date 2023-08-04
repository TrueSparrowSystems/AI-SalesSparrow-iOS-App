//
//  UserStateViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import Foundation

struct LogoutStruct: Codable {}

class UserStateViewModel: ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var isLogOutInProgress = false
    static let shared = UserStateViewModel()
    
    private init(){}
    
    func setIsUserLoggedIn() {
        print("setting logged in user")
        self.isUserLoggedIn = true
    }
    
    func logOut()  {
        guard !self.isLogOutInProgress else {return}
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
}
