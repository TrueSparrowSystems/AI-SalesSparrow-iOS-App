//
//  UserSearchViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 21/08/23.
//

import Foundation

// A struct that represents the meta data of the user
struct User: Identifiable, Codable {
    let id: String
    let name: String
}

// A struct that represents the meta data of the Search user API
struct SearchUserStruct: Codable {
    var crm_organization_user_ids: [String]
    var crm_organization_user_map_by_id: [String: Account]
}

// A class that represents the view model of the User search
class UserSearchViewModel: ObservableObject {
    @Published var userListData = SearchUserStruct(crm_organization_user_ids: [], crm_organization_user_map_by_id: [:])
    var apiService = DependencyContainer.shared.apiService
    @Published var isSearchUserInProgress = false
    let debounceTime = 0.5
    var currentSearchText = ""
    
    // A function that handles search text changes and triggers an API call for search
    func fetchData(_ searchText: String) {
        isSearchUserInProgress = true
        
        // Filter the list based on the search text
        if searchText.isEmpty {
            searchUsers(withText: "")
        } else {
            currentSearchText = searchText
            DispatchQueue.main.asyncAfter(deadline: .now() + debounceTime) {
                if searchText == self.currentSearchText {
                    self.searchUsers(withText: searchText)
                }
            }
        }
    }
    
    // A function that Perform the API call for searching users
    private func searchUsers(withText searchText: String) {
        let searchUrl = "/v1/crm-organization-users"
        let params: [String: Any] = ["q": searchText]
        
        apiService.get(type: SearchUserStruct.self, endpoint: searchUrl, params: params) { [weak self] result, _ in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.userListData.crm_organization_user_ids = results.crm_organization_user_ids
                    self?.userListData.crm_organization_user_map_by_id = results.crm_organization_user_map_by_id
                    
                case .failure(let error):
                    self?.userListData = .init(crm_organization_user_ids: [], crm_organization_user_map_by_id: [:])
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                    print("Error loading data: \(error)")
                }
                
                self?.isSearchUserInProgress = false
            }
        }
    }
}
