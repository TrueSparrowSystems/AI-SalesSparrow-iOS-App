//
//  AccountListViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 24/08/23.
//

import Foundation

// A struct that represents the meta data of the account
struct Account: Identifiable, Codable {
    var id: String
    var name: String
    var additional_fields: [String: String?]?
    var account_contact_associations_id: String?
}

struct Contact: Identifiable,Codable {
    var id: String
    var name: String
    var additional_fields: [String: String?]?
}

struct AccountContactAssociation: Codable {
    var contact_ids: [String]
}

struct Pagination: Codable {
    let pagination_identifier: String?
}

// A struct that represents the meta data of the Search account API
struct AccountListStruct: Codable {
    var account_ids: [String]
    var account_map_by_id: [String: Account]
    var contact_map_by_id: [String: Contact]
    var account_contact_associations_map_by_id: [String: AccountContactAssociation]
    var next_page_payload: Pagination?
}

struct FieldDefinition: Codable {
    let fields: [String: FieldInfo]

    struct FieldInfo: Codable {
        let type: FieldType
        let title: String
    }
}

enum FieldType: String, Codable {
    case LINK
    case TITLE
    case STRING
    case EMAIL
}

class AccountListViewModel: ObservableObject {
    @Published var accountListData = AccountListStruct(account_ids: [], account_map_by_id: [:], contact_map_by_id: [:], account_contact_associations_map_by_id: [:], next_page_payload: nil)
    
    var customFields = FieldDefinition(fields: [
//        "email": FieldDefinition.FieldInfo(type: FieldType.EMAIL, title: ""),
        "website": FieldDefinition.FieldInfo(type: FieldType.LINK, title: "Website"),
        "ppt": FieldDefinition.FieldInfo(type: FieldType.LINK, title: "Website"),
        "account_source": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "Account source"),
        "status": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "Status"),
        "last_funding": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "Last Funding"),
        "hq": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "HQ")
    ])
    
    var apiService = DependencyContainer.shared.apiService
    @Published var isFetchAccountInProgress = false
    
    func fetchData(){
        guard !self.isFetchAccountInProgress else {
            return
        }
        self.isFetchAccountInProgress = true
        
        var apiParams: [String: Any] = [:]
        if((self.accountListData.next_page_payload?.pagination_identifier) != nil){
            apiParams["pagination_identifier"] = (self.accountListData.next_page_payload!.pagination_identifier!) as String
        } else{
            //If pagination identifier is not present and account list is already fetched then return
            if(self.accountListData.account_ids.count != 0){
                isFetchAccountInProgress = false
                return
            }
        }
        
        apiService.get(type: AccountListStruct.self, endpoint: "/v1/accounts/feed", params: apiParams){
            [weak self] result, statusCode in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    // TODO: Remove this after integration testing
                    self?.accountListData = AccountListStruct(
                        account_ids: ["abc1234abc", "def5678def"],
                        account_map_by_id: [
                            "abc1234abc": Account(
                                id: "abc1234abc",
                                name: "Sample Account 1",
                                additional_fields: [
                                    "website": "www.sampleaccount1.com",
                                    "ppt": "Value1",
                                    "account_source": "Value3",
                                    "last_funding": "Value4",
                                    "hq": "Value5",
                                    "status": "Value6",
                                    "field7": "Value7",
                                    "field8": "Value8"
                                ],
                                account_contact_associations_id: "asso123asso"
                            ),
                            "def5678def": Account(
                                id: "def5678def",
                                name: "Sample Account 2",
                                additional_fields: [
                                    "website": "www.sampleaccount2.com",
                                    "title": "Value9",
                                    "email": "Value10",
                                    "linkedin": "Value11",
                                ],
                                account_contact_associations_id: "asso456asso"
                            )
                        ],
                        contact_map_by_id: [
                            "abcd1234abcd": Contact(
                                id: "abcd1234abcd",
                                name: "John Doe",
                                additional_fields: [
                                    "website": "www.sampleaccount2.com",
                                    "title": "Accountant and CEO",
                                    "email": "john123@gmail.com",
                                    "linkedin": "linkedin.com/Value11",
                                ]
                            ),
                            "efgh5678efgh": Contact(
                                id: "efgh5678efgh",
                                name: "Jane Smith",
                                additional_fields: [
                                    "website": "www.facebook.com",
                                    "title": "Founder and CEO",
                                    "email": "mayor023@gmail.com",
                                    "linkedin": "linkedin.com/kk11",
                                ]
                            )
                        ],
                        account_contact_associations_map_by_id: [
                            "asso123asso": AccountContactAssociation(
                                contact_ids: ["abcd1234abcd", "efgh5678efgh"]
                            ),
                            "asso456asso": AccountContactAssociation(contact_ids: [])
                        ]
                    )
//                    let account_ids = (self?.accountListData.account_ids ?? []) + results.account_ids
//                    let orderedSet = NSOrderedSet(array:account_ids)
//                    self?.accountListData.account_ids = orderedSet.array as! [String]
//                    self?.accountListData.account_map_by_id.merge(results.account_map_by_id) { (_, new) in new }
//                    self?.accountListData.contact_map_by_id.merge(results.contact_map_by_id) { (_, new) in new }
//                    self?.accountListData.account_contact_associations_map_by_id.merge(results.account_contact_associations_map_by_id) { (_, new) in new }
//                    self?.accountListData.next_page_payload = results.next_page_payload
                    
                case .failure(let error):
                    self?.accountListData = .init(account_ids: [], account_map_by_id: [:], contact_map_by_id: [:], account_contact_associations_map_by_id: [:], next_page_payload: nil)
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                    print("Error loading data: \(error)")
                }
                
                
                
                self?.isFetchAccountInProgress = false
            }
        }
    }
    
    func resetData(){
        self.accountListData = AccountListStruct(account_ids: [], account_map_by_id: [:], contact_map_by_id: [:], account_contact_associations_map_by_id: [:], next_page_payload: nil)
    }
}
