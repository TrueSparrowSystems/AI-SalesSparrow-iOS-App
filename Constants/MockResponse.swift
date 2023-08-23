//
//  MockResponse.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 07/08/23.
//

import Foundation

// A class with mock API responses. Used for test cases.
class MockResponse {
    static let responseObj = [
        "GET /v1/auth/salesforce/redirect-url": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "url": "https://test.salesforce.com"
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
        "POST /v1/auth/salesforce/connect": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "current_user": ["id":"123","name":"User1","email":"user1@truesparrow.com"]
                ],
            ]
        ],
        "GET /v1/accounts": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "account_ids": ["1","2","3"],
                    "account_map_by_id": ["1": ["id": "1", "name": "Test Data 1"], "2":["id": "2", "name": "Test Data 2"], "3":["id": "3", "name": "bad"]]
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
        ],
        "POST /v1/auth/logout": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data": [:] as [String : Any]
            ] as [String : Any]
        ],
        "GET /v1/users/current": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "current_user": ["id":"123","name":"User1","email":"user1@truesparrow.com"]
                ],
            ],
            "loggedOutUser":[
                "success": "false",
                "statusCode": 400,
                "error": [
                    "http_code": 400,
                    "message": "User Not logged in.",
                    "code": "INVALID_PARAMS",
                    "internal_error_identifier": "b_2"
                ] as [String : Any]
            ]
        ],
        "GET /v1/accounts/1/notes": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_ids": ["100","200"],
                    "note_map_by_id": [
                        "100":["id":"100","creator":"User1","text_preview":"This is Note text.","last_modified_time":"2019-10-12T07:20:50.52Z"],
                        "200":["id":"200","creator":"User2","text_preview":"This is Note long long text.","last_modified_time":"2019-10-12T07:20:50.58Z"]
                    ]
                ] as [String : Any],
            ],
            "emptyNoteList":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_ids": [] as [String],
                    "note_map_by_id": [:] as [String : Any],
                ] as [String : Any],
            ],
            "noteListError":[
                "success": "false",
                "statusCode": 500,
                "error": [
                    "message": "Something went wrong.",
                    "code": "",
                    "internal_error_identifier": "",
                    ]as [String : Any]
            ]
        ],
        "POST /v1/accounts/1/notes": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_id": "100"
                ],
            ]
        ],
        "GET /v1/accounts/1/notes/100": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_detail": [
                        "id":"100",
                        "creator":"User1",
                        "text":"This is Note text. This is Note long long text. this is Note long long text. this is Note long long text.",
                        "last_modified_time":"2019-10-12T07:20:50.52Z"
                    ]
                ]
            ] as [String : Any],
        ],
        "GET /v1/accounts/1/tasks": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "task_ids": [
                        "00U1e000003TUB8EAO","00U1e000003TUB8EA1"
                    ],
                    "task_map_by_id": [
                        "00U1e000003TUB8EAO":[
                            "id":"00U1e000003TUB8EAO",
                            "creator_name": "xyz",
                            "crm_organization_user_name": "abc",
                            "description": "Complete remaining task",
                            "due_date": "2019-10-12",
                            "last_modified_time": "2019-10-12T07:20:50.52Z"
                        ],
                        "00U1e000003TUB8EA1":[
                            "id":"00U1e000003TUB8EA1",
                            "creator_name": "Jakob Adison",
                            "crm_organization_user_name": "Zaire",
                            "description": "Reach out to Romit for to set a time for the next sync with their CTO",
                            "due_date": "2023-10-12",
                            "last_modified_time": "2023-08-20T07:20:50.52Z"]
                    ]
                ] as [String : Any],
            ],
            "emptyTaskList":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "task_ids": [] as [String],
                    "task_map_by_id": [:] as [String : Any],
                ] as [String : Any],
            ],
            "taskListError":[
                "success": "false",
                "statusCode": 500,
                "error": [
                    "message": "Something went wrong.",
                    "code": "",
                    "internal_error_identifier": "",
                ]as [String : Any]
            ]
        ],
        "POST /v1/auth/disconnect": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data": [:] as [String : Any]
            ] as [String : Any]
        ]
    ]
}
