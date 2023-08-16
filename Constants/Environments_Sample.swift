//
//  Environments_Sample.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

enum _BuildTarget {
    case development
    case staging
    case production
}

class Environments_Sample : ObservableObject {
    var target = _BuildTarget.production
    static let shared = Environments_Sample()
    var vars: [String: String] = [:]
    var testVars: [String: Array<String>] = [:]
    
    
    private init(){
        setVars()
    }
    
    func setVars() {
        switch self.target {
        case .development:
            self.vars = [
                "API_ENDPOINT": "https://salesparrow.coffeewith.xyz/api",
                "redirect_uri": "salessparrowdev://oauth/success",
            ]
        case .staging:
            self.vars =  [
                "API_ENDPOINT": "https://sales.quick-poc.com/",
                "redirect_uri": "salessparrowdev://oauth/success",
            ]
        case .production:
            self.vars =   [
                "API_ENDPOINT": "abc.com",
                "redirect_uri": "salessparrow://oauth/success",
            ]
        }
    }
    
    func getVars() -> [String: String]{
        return self.vars
    }
    
    func setAuthToken(authToken: String){
        self.vars["auth_code"] = authToken
        
    }
    
    func setTarget(target: _BuildTarget){
        self.target = target
        setVars()
    }
}

