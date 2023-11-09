//
//  AccountDetailViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 15/09/23.
//

import Foundation

// A struct that represents the meta data of the account detail API
struct AccountDetailRespStruct: Codable {
    var account: Account
    var account_contact_associations_map_by_id: [String: AccountContactAssociation]
    var contact_map_by_id: [String: Contact]
}

// A class that represents the view model of Account details
class AccountDetailScreenViewModel: ObservableObject {
    @Published var accountDetail = Account(id: "", name: "")
    @Published var accountContactAssociationsMapById: [String: AccountContactAssociation] = [:]
    @Published var contact_map_by_id: [String: Contact] = [:]
    
    @Published var isFetchAccountDetailInProgress = false
    @Published var errorMessage = ""
    var scrollToSection: String = ""
    var apiService = DependencyContainer.shared.apiService
    
    
    // A function to fetch account details using API.
    func fetchAccountDetail(accountId: String) {
        let endPoint = "/v1/accounts/\(accountId)"
        isFetchAccountDetailInProgress = true
        
        apiService.get(type: AccountDetailRespStruct.self, endpoint: endPoint) {
            [weak self] result, _ in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.accountDetail = results.account
                    self?.accountContactAssociationsMapById = results.account_contact_associations_map_by_id
                    self?.contact_map_by_id = results.contact_map_by_id
                    self?.isFetchAccountDetailInProgress = false
                    
                case .failure(let error):
                    self?.isFetchAccountDetailInProgress = false
                    self?.errorMessage = error.message
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
}
