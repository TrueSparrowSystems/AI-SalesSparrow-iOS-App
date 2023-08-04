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
    var vars : [String: String]?
    
    init(target: _BuildTarget){
        switch target {
        case .development:
            vars =  [
                "API_ENDPOINT": "abc.com",
            ]
        case .staging:
            vars =  [
                "API_ENDPOINT": "abc.com",
            ]
        case .production:
            vars =  [
                "API_ENDPOINT": "abc.com",
            ]
        }
    }
}
