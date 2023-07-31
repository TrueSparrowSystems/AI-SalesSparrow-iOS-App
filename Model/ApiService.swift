//
//  ApiService.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

struct AnyEncodable: Encodable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let encodableValue as Encodable:
            try container.encode(encodableValue)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Value is not encodable."))
        }
    }
}

/**
 A class that provides methods for making API requests and handling responses. The class includes a base API endpoint, and methods for making GET requests with query parameters and decoding the response into a specified type.
 */
class ApiService {
    // The base API endpoint
    // TODO: replace API endpoint
    var apiEndpoint = "Some Endpoint"
    
    
    
    /**
     Makes a GET request to the API with the specified endpoint and query parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The query parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func get<T: Decodable>(type: T.Type, endpoint: String, params: [String: Any] = [:], completion: @escaping(Result<T,APIError>, Int?) -> Void) {
        guard var urlApiEndpoint = URL(string: "\(apiEndpoint)\(endpoint)") else {
            let error = APIError.badURL
            completion(Result.failure(error), 0)
            return
        }
        var urlComponents = URLComponents(url: urlApiEndpoint, resolvingAgainstBaseURL: false)
        var queryParams: [URLQueryItem] = []
        
        for key in params.keys {
            queryParams.append(URLQueryItem(name: key, value: params[key] as? String))
        }
        
        urlComponents?.queryItems = queryParams
        urlApiEndpoint = urlComponents?.url ?? urlApiEndpoint
        
        print("urlApiEndpoint---\(urlApiEndpoint)")
        
        var requestUrl = URLRequest(url: urlApiEndpoint)
        requestUrl.httpMethod = "GET"
        
        callApi(type: type, requestUrl: requestUrl, completion: completion)
    }
    
    /**
     Makes a POST request to the API with the specified endpoint and body parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The body parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func post<T: Decodable>(type: T.Type, endpoint: String, params: [String: Any?], completion:
                            @escaping(Result<T,APIError>, Int?) -> Void){
        guard let urlApiEndpoint = URL(string: "\(apiEndpoint)\(endpoint)") else {
            let error = APIError.badURL
            completion(Result.failure(error), 0)
            return
        }
        print("urlApiEndpoint: \(urlApiEndpoint)")
        var requestUrl = URLRequest(url: urlApiEndpoint)
        
        // Encode parameters to JSON data
        let encoder = JSONEncoder()
        //              encoder.outputFormatting = .prettyPrinted
        
        var encodedDictionary = [String: AnyEncodable]()
        
        for (key, value) in params {
            if let value = value {
                encodedDictionary[key] = AnyEncodable(value)
            } else {
                encodedDictionary[key] = AnyEncodable(NSNull())
            }
        }
        
        do {
            let jsonData = try encoder.encode(encodedDictionary)
            requestUrl.httpBody = jsonData
        }
        catch let error {
            completion(Result.failure(APIError.decoding(error as? DecodingError)), 0)
            return
        }
        
        
        requestUrl.httpMethod = "POST"
        callApi(type: type, requestUrl: requestUrl, completion: completion)
    }
    
    /**
     Makes a Delete request to the API with the specified endpoint and body parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The body parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func delete<T: Decodable>(type: T.Type, endpoint: String, completion: @escaping(Result<T, APIError>, Int?) -> Void) {
        guard let urlApiEndpoint = URL(string: "\(apiEndpoint)\(endpoint)") else {
            let error = APIError.badURL
            completion(Result.failure(error), 0)
            return
        }
        
        var requestUrl = URLRequest(url: urlApiEndpoint)
        requestUrl.httpMethod = "DELETE"
        
        callApi(type: type, requestUrl: requestUrl, completion: completion)
    }
    
    
    /**
     Makes a PUT request to the API with the specified endpoint and body parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The body parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func callApi<T: Decodable>(type: T.Type, requestUrl: URLRequest, completion: @escaping(Result<T,APIError>, Int?) -> Void) {
        
        var requestUrl = requestUrl
        // Add request headers for authentication and content type to the request object
        // TODO: replace all request headers based on requirement
        requestUrl.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        requestUrl.setValue("60.0", forHTTPHeaderField: "x-salessparrow-build-number")
        requestUrl.setValue("1.1.2", forHTTPHeaderField: "x-salessparrow-app-version")
        requestUrl.setValue("16.2", forHTTPHeaderField: "x-salessparrow-device-os-version")
        requestUrl.setValue("Asia/Kolkata", forHTTPHeaderField: "x-salessparrow-device-timezone")
        requestUrl.setValue("5541F68C-E4BE-4E7D-B6F7-05C90436D124", forHTTPHeaderField: "x-salessparrow-device-uuid")
        requestUrl.setValue("iPhone15,2", forHTTPHeaderField: "x-salessparrow-device-id")
        requestUrl.setValue("iOS", forHTTPHeaderField: "x-salessparrow-device-os")
        requestUrl.setValue("Handset", forHTTPHeaderField: "x-salessparrow-device-type")
        requestUrl.setValue("Apple", forHTTPHeaderField: "x-salessparrow-device-manufacturer")
        requestUrl.setValue("true", forHTTPHeaderField: "x-salessparrow-device-has-notch")
        requestUrl.setValue("iPhone 14 Pro", forHTTPHeaderField: "x-salessparrow-device-name")
        
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.urlSession(error)), 0)
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(response.statusCode)), response.statusCode)
            } else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    let responseData = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                    DispatchQueue.main.async {
                        ApiHelper.syncEntities(responseData)
                    }
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    completion(Result.success(result), statusCode)
                } catch {
                    completion(Result.failure(.decoding(error as? DecodingError)), 0)
                }
            }
        }.resume()
    }
    
}
