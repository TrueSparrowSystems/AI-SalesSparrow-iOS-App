//
//  SuggestTaskViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 23/08/23.
//

import Foundation

// A struct that represents the meta data of the create note
struct SuggestTaskStruct: Codable {
    var text: String
}

// A class that represents the view model of the create note
class SuggestTaskViewModel: ObservableObject {
    @Published var createNoteData = SuggestTaskStruct(text: "")
    @Published var isSuggestTaskInProgress = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function to create note from given text and account id.
    func suggestTask(text: String?, onSuccess : @escaping()-> Void, onFailure : @escaping()-> Void){
        
        guard !self.isSuggestTaskInProgress else {
            return
        }
        self.isSuggestTaskInProgress = true
        
        let params: [String: Any] = ["text": text ?? ""]
        
        apiService.post(type: SuggestTaskStruct.self, endpoint: "/v1/suggestions/crm-actions", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    onSuccess()
                    self?.isSuggestTaskInProgress = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    onFailure()
                    self?.isSuggestTaskInProgress = false
                }
            }
            
        }
    }
}

