//
//  ApiError.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

// An enum that represents an error that can occur when making an API request
enum APIError: Error, CustomStringConvertible {
    
    // The error cases
    case badURL
    case urlSession(URLError?)
    case badResponse(Int)
    case decoding(DecodingError?)
    case unknown
    
    // The description of the error
    var description: String {
        switch self {
            case .badURL:
                return "badURL"
            case .urlSession(let error):
                return "urlSession error: \(error.debugDescription)"
            case .badResponse(let statusCode):
                return "bad response with status code: \(statusCode)"
            case .decoding(let decodingError):
            return "decoding error: \(String(describing: decodingError))"
            case .unknown:
                return "unknown error"
        }
    }
    
    // The localized description of the error
    var localizedDescription: String {
        switch self {
            case .badURL, .unknown:
               return "something went wrong"
            case .urlSession(let urlError):
                return urlError?.localizedDescription ?? "something went wrong"
            case .badResponse(_):
                return "something went wrong"
            case .decoding(let decodingError):
                return decodingError?.localizedDescription ?? "something went wrong"
        }
    }
}
