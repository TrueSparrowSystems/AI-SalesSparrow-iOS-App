//
//  MockResponse.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 07/08/23.
//

import Foundation

class MockResponse {
    static let responseObj = [
        "/salesForce-connect-uri": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "url": ""
                ],
            ] ,
            "login-error":[
                "statusCode": 400,
                "error": [
                    "http_code": 400,
                    "message": "At least one parameter is invalid or missing.",
                    "code": "INVALID_PARAMS",
                    "internal_error_identifier": "b_2",
                    "param_errors": [
                        [
                            "parameter": "email",
                            "message": "The email address you entered is incorrect. Please double check and try again."
                        ]
                    ]
                ]
            ]
        ]
    ]
}
