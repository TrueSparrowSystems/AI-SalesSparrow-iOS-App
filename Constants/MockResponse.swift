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
        "GET /v1/users/current": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "current_user": [
                        "id":"user_123",
                        "name":"Salesforce User",
                        "email":"sales@truesparrow.com"]
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
                    "current_user": [
                        "id":"user_123",
                        "name":"Salesforce User",
                        "email":"sales@truesparrow.com"
                    ]
                ],
            ]
        ],
        
        "POST /v1/auth/logout": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data": [:] as [String : Any]
            ] as [String : Any]
        ],
        
        "POST /v1/auth/disconnect": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data": [:] as [String : Any]
            ] as [String : Any]
        ],
        
        "GET /v1/accounts/feed": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "account_ids": ["account_1", "account_2", "account_3"],
                    "account_map_by_id": [
                        "account_1": [
                            "id": "account_1",
                            "name": "Test Account 1",
                            "additional_fields": [
                                "website": "https://account.com"
                            ],
                            "account_contact_associations_id": "account_contact_association_1"
                        ] as [String : Any],
                        "account_2": [
                            "id": "account_2",
                            "name": "Test Account 2",
                            "additional_fields": [
                                "website": "https://account.com"
                            ],
                            "account_contact_associations_id": "account_contact_association_2"
                        ] as [String : Any],
                        "account_3": [
                            "id": "account_3",
                            "name": "Test Account 3",
                            "additional_fields": [
                                "website": "https://account.com"
                            ],
                            "account_contact_associations_id": "account_contact_association_3"
                        ] as [String : Any],
                    ],
                    "contact_map_by_id": [
                        "contact_1": [
                            "id": "contact_1",
                            "name": "Test Contact 1",
                            "additional_fields": [
                                "email": "contact_1@truesparrow.com"
                            ]
                        ] as [String : Any],
                        "contact_2": [
                            "id": "contact_2",
                            "name": "Test Contact 2",
                            "additional_fields": [
                                "email": "contact_2@truesparrow.com"
                            ]
                        ] as [String : Any],
                        "contact_3": [
                            "id": "contact_3",
                            "name": "Test Contact 3",
                            "additional_fields": [
                                "email": "contact_3@truesparrow.com"
                            ]
                        ] as [String : Any],
                    ],
                    "account_contact_associations_map_by_id": [
                        "account_contact_association_1": [
                            "contact_ids": ["contact_1", "contact_2"]
                        ],
                        "account_contact_association_2": [
                            "contact_ids": ["contact_2", "contact_3"]
                        ],
                        "account_contact_association_3": [
                            "contact_ids": ["contact_3"]
                        ],
                    ],
                   "next_page_payload" : [
                       "pagination_identifier": "next_page"
                   ],
                ] as [String : Any],
            ] as [String : Any],
        ],
        
        "GET /v1/accounts": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "account_ids": ["account_1","account_2","account_3"],
                    "account_map_by_id": [
                        "account_1": [
                            "id": "account_1",
                            "name": "Test Account 1"
                        ],
                        "account_2":[
                            "id": "account_2",
                            "name": "Test Account 2"
                        ],
                        "account_3":[
                            "id": "account_3",
                            "name": "Test Account 3"
                        ]
                    ]
                ] as [String : Any],
            ] as [String : Any],
            "searchResponseWithQuery":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "account_ids": ["account_1","account_2","account_3"],
                    "account_map_by_id": [
                        "account_1": [
                            "id": "account_1",
                            "name": "Mock Account 1"
                        ],
                        "account_2":[
                            "id": "account_2",
                            "name": "Mock Account 2"
                        ],
                        "account_3":[
                            "id": "account_3",
                            "name": "Mock Account 3"
                        ]
                    ]
                ] as [String : Any],
            ] as [String : Any]
        ],
        
        "GET /v1/accounts/account_1/notes": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_ids": ["note_100","note_200"],
                    "note_map_by_id": [
                        "note_100":[
                            "id":"note_100",
                            "creator":"User1",
                            "text_preview":"This is Note text.",
                            "last_modified_time":"2019-10-12T07:20:50.52Z"
                        ],
                        "note_200":[
                            "id":"note_200",
                            "creator":"User2",
                            "text_preview":"This is Note long long text.",
                            "last_modified_time":"2019-10-12T07:20:50.58Z"
                        ]
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
        
        "POST /v1/accounts/account_1/notes": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_id": "note_100"
                ],
            ]
        ],
        
        "POST /v1/suggestions/crm-actions": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "text": "some random text"
                ],
            ]
        ],
        
        "GET /v1/accounts/account_1/notes/note_100": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "note_detail": [
                        "id":"note_100",
                        "creator":"User1",
                        "text":"This is Note text. This is Note long long text. this is Note long long text. this is Note long long text.",
                        "last_modified_time":"2019-10-12T07:20:50.52Z"
                    ]
                ]
            ] as [String : Any],
        ],
        
        "DELETE /v1/accounts/account_1/notes/note_100": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data": [:] as [String : Any]
            ] as [String : Any],
            "deleteNoteError":[
                "success": "false",
                "statusCode": 400,
                "error": [
                    "message": "Note cannot be deleted.",
                    "code": "",
                    "internal_error_identifier": "",
                ]as [String : Any]
            ]
        ],
        
        "GET /v1/accounts/account_1/tasks": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "task_ids": [
                        "task_1","task_2"
                    ],
                    "task_map_by_id": [
                        "task_1":[
                            "id":"task_1",
                            "creator_name": "xyz",
                            "crm_organization_user_name": "abc",
                            "description": "Complete remaining task",
                            "due_date": "2019-10-12",
                            "last_modified_time": "2019-10-12T07:20:50.52Z"
                        ],
                        "task_2":[
                            "id":"task_2",
                            "creator_name": "Jakob Adison",
                            "crm_organization_user_name": "Zaire",
                            "description": "Reach out to Romit for to set a time for the next sync with their CTO",
                            "due_date": "2023-10-12",
                            "last_modified_time": "2023-08-20T07:20:50.52Z"
                        ]
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
        
        "DELETE /v1/accounts/account_1/tasks/task_1": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data": [:] as [String : Any]
            ],
            "deleteTaskError":[
                "success": "false",
                "statusCode": 400,
                "error": [
                    "message": "Task cannot be deleted.",
                    "code": "",
                    "internal_error_identifier": "",
                ]as [String : Any]
            ]
        ],
        
        "GET /v1/users": [
            "default":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "user_ids": ["1","2","3"],
                    "user_map_by_id": [
                        "1": [
                            "id": "1",
                            "name": "Test User"
                        ],
                        "2":[
                            "id": "2",
                            "name": "Elon Musk"
                        ],
                        "3":[
                            "id": "3",
                            "name": "Mark Zuckerberg"
                        ]
                    ]
                ] as [String : Any],
            ],
            "searchResponseWithQuery":[
                "success": "true",
                "statusCode": 200,
                "data":[
                    "user_ids": ["1","2","3"],
                    "user_map_by_id": [
                        "1": [
                            "id": "1",
                            "name": "Mock User"
                        ],
                        "2":[
                            "id": "2",
                            "name": "Alex Hunter"
                        ],
                        "3":[
                            "id": "3",
                            "name": "Lukas vaskas"
                        ]
                    ]
                ] as [String : Any],
            ]
        ]
    ]
}
