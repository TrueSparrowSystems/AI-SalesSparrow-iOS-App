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
    
    func setIsUserLoggedIn() {
        print("setting logged in user")
        self.isUserLoggedIn = true
    }
    
    func logOut()  {
        guard !self.isLogOutInProgress else {return}
        self.isLogOutInProgress = true
        ApiService().post(type: LogoutStruct.self, endpoint: ""){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.isUserLoggedIn = false
                    self?.isLogOutInProgress = false
                }
                
            case .failure(let error):
                print("error loading data: \(error)")
                self?.isLogOutInProgress = false
            }
            
        }
    }
}
