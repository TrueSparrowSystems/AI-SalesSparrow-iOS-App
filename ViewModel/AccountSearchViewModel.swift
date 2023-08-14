//
//  AccountSearchViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import Foundation

struct Account: Identifiable, Codable {
    let id: String
    let name: String
}

struct SearchAccountStruct: Codable {
    var account_ids: [String]
    var account_map_by_id: [String: Account]
}

class AccountSearchViewModel: ObservableObject {
    @Published var accountListData = SearchAccountStruct(account_ids: [], account_map_by_id: [:])
    var apiService = DependencyContainer.shared.apiService
    
    // A function that handles search text changes and triggers an API call for search
    func fetchData(_ searchText: String) {
        // Filter the list based on the search text
        if searchText.isEmpty {
//            resetData() // If search text is empty, reset the list to show all accounts
            searchAccounts(withText: "")
        } else {
            searchAccounts(withText: searchText)
        }
    }
    
    private func searchAccounts(withText searchText: String) {
        // Perform the API call for searching accounts
        print("Query String--> \(searchText)")
        let searchUrl = "/v1/accounts"
        let params: [String: Any] = ["q": searchText]
        
        
        apiService.get(type: SearchAccountStruct.self, endpoint: searchUrl, params: params) { [weak self] result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.accountListData.account_ids = results.account_ids
                    self?.accountListData.account_map_by_id = results.account_map_by_id
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.accountListData = .init(account_ids: [], account_map_by_id: [:])
                }
                print("Error loading data: \(error)")
                // Handle error if needed
            }
        }
    }
}

