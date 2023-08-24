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
    var website: String?
}

// A struct that represents the meta data of the Search account API
struct AccountListStruct: Codable {
    var account_ids: [String]
    var account_map_by_id: [String: Account]
    var meta: Meta?
}

class AccountListViewModel: ObservableObject {
    @Published var accountListData = AccountListStruct(account_ids: [], account_map_by_id: [:], meta: nil)
    var apiService = DependencyContainer.shared.apiService
    @Published var isFetchAccountInProgress = false
    
    func fetchData(){
        guard !self.isFetchAccountInProgress else {
            return
        }
        self.isFetchAccountInProgress = true
        
        //TODO: replace params with `[:]` once api is available from BE
        var apiParams: [String: Any] = ["q":""]
        if((self.accountListData.meta?.next_page_payload?.pagination_identifier) != nil){
            apiParams["pagination_identifier"] = (self.accountListData.meta!.next_page_payload!.pagination_identifier!) as String
        }
        
        //TODO: remove this dummy data once api is available
//        self.accountListData.account_ids = ["account_1","account_2","account_3"]
//        self.accountListData.account_map_by_id = [
//            "account_1": Account(id: "account_1", name: "Test Account 1", website: "https://account.com"), "account_2":Account(id: "account_2", name: "Test Account 2", website: "https://truesparrow.com"), "account_3":Account(id: "account_3", name: "Test Account 3")
//        ]
        
        apiService.get(type: AccountListStruct.self, endpoint: "/v1/accounts", params: apiParams){
            [weak self] result, statusCode in
            
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
//                        let account_ids = (self?.accountListData.account_ids ?? []) + results.account_ids
//                        let orderedSet = NSOrderedSet(array:account_ids)
//                        self?.accountListData.account_ids = orderedSet.array as! [String]
                        self?.accountListData.account_ids = results.account_ids
                        self?.accountListData.account_map_by_id.merge(results.account_map_by_id) { (_, new) in new }
                        self?.accountListData.meta = results.meta
                        
                    case .failure(let error):
                        self?.accountListData = .init(account_ids: [], account_map_by_id: [:])
                        ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                        print("Error loading data: \(error)")
                    }
                    
                   
                    
                    self?.isFetchAccountInProgress = false
                }
        }
    }
}
