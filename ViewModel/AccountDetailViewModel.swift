//
//  AccountDetailViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 15/09/23.
//

import Foundation

// A struct that represents the meta data of the account detail API
struct AccountDetail: Codable {
    var account_detail: AccountDetailStruct
}

// A struct that represents the meta data of the account details
struct AccountDetailStruct : Codable {
    var id: String
    var name: String
    var additional_fields: [String:String?]?
    var account_contact_associations_id: String?
    var account_contact_associations_map_by_id: [String: AccountContactAssociation]?
    var contact_map_by_id: [String: Contact]?
}

// A class that represents the view model of Account details
class AccountDetailScreenViewModel: ObservableObject {
    @Published var accountDetail = AccountDetailStruct(id: "", name: "")
    @Published var isFetchAccountDetailInProgress = false
    @Published var errorMessage = ""
    var scrollToSection: String = ""
    var apiService = DependencyContainer.shared.apiService
    
    var customFields = FieldDefinition(fields: [
//        "email": FieldDefinition.FieldInfo(type: FieldType.EMAIL, title: ""),
        "website": FieldDefinition.FieldInfo(type: FieldType.LINK, title: "Website"),
        "ppt": FieldDefinition.FieldInfo(type: FieldType.LINK, title: "PPT"),
        "title": FieldDefinition.FieldInfo(type: FieldType.TITLE, title: ""),
        "email": FieldDefinition.FieldInfo(type: FieldType.EMAIL, title: ""),
        "linkedin": FieldDefinition.FieldInfo(type: FieldType.LINK, title: "Linkedin"),
        "account_source": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "Account source"),
        "status": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "Status"),
        "last_funding": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "Last Funding"),
        "hq": FieldDefinition.FieldInfo(type: FieldType.STRING, title: "HQ")
    ])
    
    // A function to fetch account details using API.
    func fetchAccountDetail(accountId: String){
        let endPoint = "/v1/accounts/\(accountId)"
        isFetchAccountDetailInProgress = true
        
        apiService.get(type: AccountDetail.self, endpoint: endPoint){
            [weak self] result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.accountDetail = results.account_detail
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

