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
    var additional_fields: [String: String?]
    var account_contact_associations_id: String
}

struct Contact: Identifiable,Codable {
    var id: String
    var name: String
    var additional_fields: [String: String?]
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

class AccountListViewModel: ObservableObject {
    @Published var accountListData = AccountListStruct(account_ids: [], account_map_by_id: [:], contact_map_by_id: [:], account_contact_associations_map_by_id: [:], next_page_payload: nil)
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
        
        //TODO: remove this dummy data once api is available
        self.accountListData.account_ids = ["account_1","account_2","account_3"]
        self.accountListData.account_map_by_id = [
            "account_1":
                Account(id: "account_1",
                        name: "Test Account 1",
                        additional_fields: ["website": "https://account.com"],
                        account_contact_associations_id: "account_contact_association_1"
                       ),
            "account_2":
                Account(
                    id: "account_2",
                    name: "Test Account 2",
                    additional_fields: ["website": "https://truesparrow.com"],
                    account_contact_associations_id: "account_contact_association_2"
                ),
            "account_3":
                Account(
                    id: "account_3",
                    name: "Test Account 3",
                    additional_fields: ["website": "https://truesparrow.com"],
                    account_contact_associations_id: "account_contact_association_3"
                )
        ]
        self.accountListData.contact_map_by_id = [
            "contact_1":
                Contact(
                    id: "contact_1",
                    name: "Test Contact 1",
                    additional_fields: ["email": "contact_1@truesparrow.com"]
                ),
            "contact_2":
                Contact(
                    id: "contact_2",
                    name: "Test Contact 2",
                    additional_fields: ["email": "contact_2@truesparrow.com"]
                ),
        ]
        self.accountListData.account_contact_associations_map_by_id = [
            "account_contact_association_1":
                AccountContactAssociation(
                    contact_ids: ["contact_1", "contact_2"]
                ),
            "account_contact_association_2":
                AccountContactAssociation(
                    contact_ids: ["contact_2", "contact_1"]
                ),
            "account_contact_association_3":
                AccountContactAssociation(
                    contact_ids:  ["contact_1"]
                )
        ]
        
        apiService.get(type: AccountListStruct.self, endpoint: "/v1/accounts/feed", params: apiParams){
            [weak self] result, statusCode in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    let account_ids = (self?.accountListData.account_ids ?? []) + results.account_ids
                    let orderedSet = NSOrderedSet(array:account_ids)
                    self?.accountListData.account_ids = orderedSet.array as! [String]
                    self?.accountListData.account_map_by_id.merge(results.account_map_by_id) { (_, new) in new }
                    self?.accountListData.contact_map_by_id.merge(results.contact_map_by_id) { (_, new) in new }
                    self?.accountListData.account_contact_associations_map_by_id.merge(results.account_contact_associations_map_by_id) { (_, new) in new }
                    self?.accountListData.next_page_payload = results.next_page_payload
                    
                case .failure(let error):
                    //TODO: Uncomment this line once API is available
                    //                        self?.accountListData = .init(account_ids: [], account_map_by_id: [:], contact_map_by_id: [:], account_contact_associations_map_by_id: [:], next_page_payload: nil)
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
