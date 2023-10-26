//
//  ApiError.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

// Error structure returned from BE.
struct ErrorStruct: Error, Decodable {
    var message: String
    var code: String?
    var internal_error_identifier: String?
    var param_errors: [Dictionary<String, String>]?
    var error_data: [Dictionary<String, String>]?
}

// Class to handle errors.
struct APIError {
    func convertDataToErrorStruct(error: [String: Any]) -> ErrorStruct {
        do {
            let errorData = try JSONSerialization.data(withJSONObject: error, options: [])
            return try JSONDecoder().decode(ErrorStruct.self, from: errorData)
        } catch {
            return ErrorStruct(message: "Something went wrong")
        }
    }
    
    func badURL() -> ErrorStruct {
        return convertDataToErrorStruct(error: ["message": "Bad URL"])
    }
    func decodingError(error: DecodingError?) -> ErrorStruct {
        return convertDataToErrorStruct(error: ["message": "Something went wrong"])
    }
    func internalServerError() -> ErrorStruct {
        return convertDataToErrorStruct(error: ["message": "Something went wrong"])
    }
   
}
