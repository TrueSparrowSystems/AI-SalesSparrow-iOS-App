//
//  ApiError.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

struct ErrorStruct: Error,Decodable {
    var message: String
    var code: String?
    var internal_error_identifier: String?
    var param_errors: [Dictionary<String, String>]?
}

struct APIError {
    func convertDataToErrorStruct(data: [String: String]) -> ErrorStruct{
        do{
            let errorData = try JSONSerialization.data(withJSONObject: data, options: [])
            return try JSONDecoder().decode(ErrorStruct.self, from: errorData)
        }catch{
            return ErrorStruct(message: "Unknown Error")
        }
    }
    
    func badURL() -> ErrorStruct {
        return convertDataToErrorStruct(data:  ["message":"Bad URL"])
    }
    func urlSession(error: URLError?) -> ErrorStruct {
        return convertDataToErrorStruct(data: ["message":"urlSession error: \(error.debugDescription)"])
    }
    func badResponse(statusCode: Int) -> ErrorStruct {
        return convertDataToErrorStruct(data: ["message":"bad response with status code: \(statusCode)"])
    }
    func decodingError(error: DecodingError?) -> ErrorStruct {
        return convertDataToErrorStruct(data: ["message":"decoding error: \(String(describing: error))"])
    }
   
}

