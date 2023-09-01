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

// Sample environment file. Need to be copied in Environments.swift with appropriate values.
class Environments_Sample : ObservableObject {
    var target = _BuildTarget.production
    static let shared = Environments_Sample()
    var vars: [String: String] = [:]
    var testVars: [String: Array<String>] = [:]
    
    
    private init(){
        setVars()
    }
    
    // A function to set vars based on the target.
    func setVars() {
        switch self.target {
        case .development:
            self.vars = [
                "API_ENDPOINT": "https://staging.sales.truesparrow.com/api",
                "redirect_uri": "salessparrowdev://oauth/success",
            ]
        case .staging:
            self.vars =  [
                "API_ENDPOINT": "https://staging.sales.truesparrow.com/api",
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

