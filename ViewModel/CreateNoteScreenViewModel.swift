//
//  CreateNoteScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 03/08/23.
//

import Foundation

// A struct that represents the meta data of the create note
struct CreateNoteStruct: Codable {
    var note_id: String
}

// A class that represents the view model of the create note
class CreateNoteScreenViewModel: ObservableObject {
    @Published var createNoteData = CreateNoteStruct(note_id: "")
    @Published var isCreateNoteInProgress = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function to create note from given text and account id.
    func createNote(text: String?, accountId: String, onSuccess : @escaping()-> Void, onFailure : @escaping()-> Void){
        
        guard !self.isCreateNoteInProgress else {
            return
        }
        self.isCreateNoteInProgress = true
        
        let params: [String: Any] = ["text": text ?? ""]
        
        apiService.post(type: CreateNoteStruct.self, endpoint: "/v1/accounts/\(accountId)/notes", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    onSuccess()
                    self?.isCreateNoteInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Note is saved to your Salesforce Account"))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    onFailure()
                    self?.isCreateNoteInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
}
