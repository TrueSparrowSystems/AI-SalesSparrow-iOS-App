//
//  CreateNoteScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 03/08/23.
//

import Foundation

// A struct that represents the meta data of the list
struct CreateNoteStruct: Codable {
    var note_id: String
}

// A class that represents the view model of the LoginScreen
class CreateNoteScreenViewModel: ObservableObject {
    @Published var createNoteData = CreateNoteStruct(note_id: "")
    @Published var isCreateNoteInProgress = false
    
    func createNote(text: String?, accountId: String, onSuccess : @escaping()-> Void, onFailure : @escaping()-> Void){
        
        guard !self.isCreateNoteInProgress else {
            return
        }
        self.isCreateNoteInProgress = true
        
        //TODO: Remove this once the login api is implemented
        onSuccess()
        self.isCreateNoteInProgress = false
        
        
        ApiService().get(type: CreateNoteStruct.self, endpoint: "accounts/\(accountId)/notes"){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    onSuccess()
                    self?.isCreateNoteInProgress = false
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    onFailure()
                    self?.isCreateNoteInProgress = false
                }
            }
            
        }
    }
}
