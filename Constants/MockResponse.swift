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
                "success": "false",
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
                ] as [String : Any]
            ]
        ],
        "/api/v1/accounts": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "account_ids": ["1","2","3"],
                    "account_map_by_id": ["1": ["id": "1", "name": "Test Data 1"], "2":["id": "2", "name": "acd"], "3":["id": "3", "name": "bad"]]
                ] as [String : Any],
            ] as [String : Any],
            "searchResponseWithQuery":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "account_ids": ["1","2","3"],
                    "account_map_by_id": ["1": ["id": "1", "name": "Mock Account 1"], "2":["id": "2", "name": "acd"], "3":["id": "3", "name": "bad"]]
                ] as [String : Any],
            ] as [String : Any]
        ]
    ]
}
