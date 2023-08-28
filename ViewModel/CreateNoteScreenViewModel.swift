//
//  CreateNoteScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 03/08/23.
//

import Foundation

// A struct that represents the meta data of the create note API
struct CreateNoteStruct: Codable {
    var note_id: String
}

// A struct that represents the meta data of the suggestion entity
struct SuggestionStruct: Codable, Equatable {
    var description: String
    var due_date: String?
}

// A struct that represents the meta data of the generate suggested task API
struct GenerateSuggestionStruct: Codable, Equatable {
    var add_task_suggestions: [SuggestionStruct]
}

// A class that represents the view model of the create note
class CreateNoteScreenViewModel: ObservableObject {
    @Published var createNoteData = CreateNoteStruct(note_id: "")
    @Published var suggestedTaskData = GenerateSuggestionStruct(add_task_suggestions: [])
    @Published var isCreateNoteInProgress = false
    @Published var isSuggestionGenerationInProgress = false
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
                    self?.generateSuggestion(text: text!, onSuccess: {}, onFailure: {})
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
    
    // A function to generate suggestion note from given text.
    func generateSuggestion(text: String, onSuccess : @escaping()-> Void, onFailure : @escaping()-> Void){
        guard !self.isSuggestionGenerationInProgress else {
            return
        }
        self.isSuggestionGenerationInProgress = true
        
        let params: [String: Any] = ["text": text]
        
        apiService.post(type: GenerateSuggestionStruct.self, endpoint: "/v1/suggestions/crm-actions", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    onSuccess()
                    self?.suggestedTaskData.add_task_suggestions = results.add_task_suggestions
                    self?.isSuggestionGenerationInProgress = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    onFailure()
                    self?.isSuggestionGenerationInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
    
    func removeSuggestion(at index: Int) {
        if suggestedTaskData.add_task_suggestions.indices.contains(index) {
            suggestedTaskData.add_task_suggestions.remove(at: index)
        }
    }
}
