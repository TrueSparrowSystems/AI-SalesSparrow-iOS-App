//
//  AccountSearchViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import Foundation

// A struct that represents the meta data of the account
struct Account: Identifiable, Codable {
    let id: String
    let name: String
}

// A struct that represents the meta data of the Search account API
struct SearchAccountStruct: Codable {
    var account_ids: [String]
    var account_map_by_id: [String: Account]
}

// A class that represents the view model of the LoginScreen
class AccountSearchViewModel: ObservableObject {
    @Published var accountListData = SearchAccountStruct(account_ids: [], account_map_by_id: [:])
    var apiService = DependencyContainer.shared.apiService
    @Published var isSearchAccountInProgress = false
    let debounceTime = 0.5
    var currentSearchText = ""
    
    // A function that handles search text changes and triggers an API call for search
    func fetchData(_ searchText: String) {
        isSearchAccountInProgress = true
        
        // Filter the list based on the search text
        if searchText.isEmpty {
            searchAccounts(withText: "")
        } else {
            currentSearchText = searchText
            DispatchQueue.main.asyncAfter(deadline: .now() + debounceTime){
                if(searchText == self.currentSearchText){
                    self.searchAccounts(withText: searchText)
                }
            }
        }
    }
    
    // A function that Perform the API call for searching accounts
    private func searchAccounts(withText searchText: String) {
        print("Query String--> \(searchText)")
        let searchUrl = "/v1/accounts"
        let params: [String: Any] = ["q": searchText]
        
        apiService.get(type: SearchAccountStruct.self, endpoint: searchUrl, params: params) { [weak self] result, statusCode in            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.accountListData.account_ids = results.account_ids
                    self?.accountListData.account_map_by_id = results.account_map_by_id
                    
                case .failure(let error):
                    self?.accountListData = .init(account_ids: [], account_map_by_id: [:])
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                    print("Error loading data: \(error)")
                }
                
                self?.isSearchAccountInProgress = false
            }
        }
    }
}

