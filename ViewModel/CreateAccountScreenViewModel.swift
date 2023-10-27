//
//  CreateAccountScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 26/10/23.
//

import Foundation

struct AccountDescriptionStruct: Codable {
    var fields: [AccountField]
}

struct AccountField: Codable {
    var defaultValue: String?
    var label: String
    var length: Int?
    var name: String
    var picklistValues: [PicklistValue]?
    var type: String?
}

struct PicklistValue: Codable {
    var active: Bool
    var label: String?
    var value: String?
}

class CreateAccountScreenViewModel: ObservableObject {
    @Published var accountFields = AccountDescriptionStruct(fields: [])
    
    var apiService = DependencyContainer.shared.apiService
    
    func fetchAccountFields(onSuccess: @escaping() -> Void) {
        guard accountFields.fields.count == 0 else {
            onSuccess()
            return
        }
        
        apiService.get(type: AccountDescriptionStruct.self, endpoint: "/v1/accounts/describe") {
            [weak self] result, _ in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    print(results)
                    self?.accountFields.fields = results.fields
                    onSuccess()
                    
                case .failure(let error):
                    print(error)
                    // TODO: remove the following hardcoding once api is deployed
                    self?.accountFields.fields =  [
                        AccountField(
                            label: "Account Name",
                            length: 255,
                            name: "Name",
                            type: "string"
                        ),
                        AccountField(
                            label: "Website",
                            length: 255,
                            name: "Website",
                            type: "url"
                        ),
                        AccountField(
                            label: "Establishment Year",
                            length: 255,
                            name: "Establishment_Year__c",
                            picklistValues: [
                                PicklistValue(
                                    active: true,
                                    label: "2023",
                                    value: "2023"
                                ),
                                PicklistValue(
                                    active: true,
                                    label: "Before 2020",
                                    value: "Before 2020"
                                )
                            ],
                            type: "picklist"
                        ),
                        AccountField(
                            defaultValue: "Ready To Inspect",
                            label: "Status",
                            length: 255,
                            name: "Status__c",
                            picklistValues: [
                                PicklistValue(
                                    active: true,
                                    label: "Ready To Inspect",
                                    value: "Ready To Inspect"
                                ),
                                PicklistValue(
                                    active: true,
                                    label: "Unsubscribed",
                                    value: "Unsubscribed"
                                )
                            ],
                            type: "picklist"
                        )
                    ]
                    onSuccess()
                }
            }
        }
    }
}
