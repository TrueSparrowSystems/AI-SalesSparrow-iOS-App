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

class MockAPIService: ApiService {
    
    override func callApi<T: Decodable>(type: T.Type, requestUrl: URLRequest, endpoint: String, completion: @escaping(Result<T, ErrorStruct>, Int?) -> Void) {
        do{
            var caseIdentifierFound: String = "default"
            Environments.shared.testVars["testCaseIdentifiers"]?.forEach { testCaseIdentifier in
                if let response = MockResponse.responseObj[endpoint]?[testCaseIdentifier] {
                    caseIdentifierFound = testCaseIdentifier
                }
            }
            let response = MockResponse.responseObj[endpoint]?[caseIdentifierFound]
            
            if(response?["statusCode"] as! Int == 200) {
                do{
                    let responseData = try JSONSerialization.data(withJSONObject: response?["data"]! as Any, options: [])
                    let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                    
                    DispatchQueue.main.async {
                        ApiHelper.syncEntities(response!)
                    }
                    completion(Result.success(decodedData), (response?["statusCode"] as! Int))
                } catch let decodingError {
                    completion(Result.failure(APIError().decodingError(error: (decodingError as! DecodingError))), 0)
                }
            } else {
                if(response?["statusCode"] as! Int == 401){
                    UserStateViewModel.shared.logOut()
                }
                let errorData = try JSONSerialization.data(withJSONObject: response?["error"]! as Any, options: [])
                
                let error = try JSONDecoder().decode(ErrorStruct.self, from: errorData)
                completion(Result.failure(error), (response?["statusCode"] as! Int))
            }
        }catch let decodingError {
            completion(Result.failure(APIError().decodingError(error: (decodingError as! DecodingError))), 0)
        }
    }
}

/**
 A class that provides methods for making API requests and handling responses. The class includes a base API endpoint, and methods for making GET requests with query parameters and decoding the response into a specified type.
 */
class ApiService {
    
    /**
     Makes a GET request to the API with the specified endpoint and query parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The query parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    
    let dev = false
    
    func get<T: Decodable>(type: T.Type, endpoint: String, params: [String: Any] = [:], completion: @escaping(Result<T, ErrorStruct>, Int?) -> Void) {
        let envVars = Environments.shared.getVars()
        let apiBaseEndpoint: String = envVars["API_ENDPOINT"] ?? ""
        
        guard var urlApiEndpoint = URL(string: "\(apiBaseEndpoint)\(endpoint)") else {
            let error = APIError().badURL()
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
        
        if(dev){
            print("urlApiEndpoint---\(urlApiEndpoint)")
        }
        var requestUrl = URLRequest(url: urlApiEndpoint)
        requestUrl.httpMethod = "GET"
        
        callApi(type: type, requestUrl: requestUrl,endpoint: endpoint, completion: completion)
    }
    
    /**
     Makes a POST request to the API with the specified endpoint and body parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The body parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func post<T: Decodable>(type: T.Type, endpoint: String, params: [String: Any?] = [:], completion:
                            @escaping(Result<T, ErrorStruct>, Int?) -> Void){
        let envVars = Environments.shared.getVars()
        let apiBaseEndpoint: String = envVars["API_ENDPOINT"] ?? ""
        
        guard let urlApiEndpoint = URL(string: "\(apiBaseEndpoint)\(endpoint)") else {
            let error = APIError().badURL()
            completion(Result.failure(error), 0)
            return
        }
        if(dev){
            print("urlApiEndpoint: \(urlApiEndpoint)")
        }
        var requestUrl = URLRequest(url: urlApiEndpoint)
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            requestUrl.httpBody = jsonData
        }
        catch let decodingError {
            completion(Result.failure(APIError().decodingError(error: (decodingError as! DecodingError))), 0)
            return
        }
        
        
        requestUrl.httpMethod = "POST"
        callApi(type: type, requestUrl: requestUrl,endpoint: endpoint, completion: completion)
    }
    
    /**
     Makes a Delete request to the API with the specified endpoint and body parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The body parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func delete<T: Decodable>(type: T.Type, endpoint: String, completion: @escaping(Result<T, ErrorStruct>, Int?) -> Void) {
        let envVars = Environments.shared.getVars()
        let apiBaseEndpoint: String = envVars["API_ENDPOINT"] ?? ""
        
        guard let urlApiEndpoint = URL(string: "\(apiBaseEndpoint)\(endpoint)") else {
            let error = APIError().badURL()
            completion(Result.failure(error), 0)
            return
        }
        
        var requestUrl = URLRequest(url: urlApiEndpoint)
        requestUrl.httpMethod = "DELETE"
        
        callApi(type: type, requestUrl: requestUrl,endpoint: endpoint, completion: completion)
    }
    
    
    /**
     Makes a PUT request to the API with the specified endpoint and body parameters, and decodes the response into the specified type.
     
     - Parameters:
     - type: The type to decode the response into.
     - endpoint: The endpoint to append to the base API endpoint.
     - params: The body parameters to include in the request.
     - completion: A closure to call with the decoded response and the HTTP status code of the response.
     */
    func callApi<T: Decodable>(type: T.Type, requestUrl: URLRequest, endpoint: String, completion: @escaping(Result<T, ErrorStruct>, Int?) -> Void) {
        
        var requestUrl = requestUrl
        let deviceHeaderParams = DeviceSettingManager.shared.deviceHeaderParams
        if(dev){
            print(HTTPCookieStorage.shared.cookies)
        }
        // Add request headers for authentication and content type to the request object
        requestUrl.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        requestUrl.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in deviceHeaderParams {
            requestUrl.setValue(BasicHelper.toString(value), forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if(self.dev){
                print("---------------response----------\(response)")
                print("---------------error----------\(error)")
            }
            if let error = error as? URLError {
                completion(Result.failure(APIError().urlSession(error: error)), 0)
            }
            else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                var errorData: ErrorStruct
                
                do {
                    if(response.statusCode == 401){
                        UserStateViewModel.shared.logOut()
                    }
                    
                    if(self.dev){
                        let errorDataStr = String(decoding: data!, as: UTF8.self)
                        print("---------------errorDataStr-----------\(errorDataStr)")
                    }
                    errorData = try JSONDecoder().decode(ErrorStruct.self, from: data!)
                    
                } catch {
                    errorData = APIError().internalServerError()
                }
                
                if(self.dev){
                    print("---------------errorData----------\(errorData)")
                }
                completion(Result.failure(errorData), response.statusCode)
                
            } else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    let responseData = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                    DispatchQueue.main.async {
                        ApiHelper.syncEntities(responseData)
                    }
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    completion(Result.success(result), statusCode)
                } catch let decodingError {
                    completion(Result.failure(APIError().decodingError(error: (decodingError as! DecodingError))), 0)
                }
            }
        }.resume()
    }
    
}
