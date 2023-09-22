//
//  EditNoteScreenViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 21/09/23.
//

import Foundation

// A struct that represents the meta data of the note details API
struct EditNoteRespStruct: Codable {
}

// A class that represents the view model of Note details
class EditNoteScreenViewModel: ObservableObject {
    @Published var currentNote = NoteDetailStruct(id: "", creator: "", text: "", last_modified_time: "")
    @Published var isFetchNoteDetailInProgress = false
    @Published var isEditNoteInProgress = false
    @Published var errorMessage = ""
    var apiService = DependencyContainer.shared.apiService
    
    // A function to fetch note details using API.
    func fetchNoteDetail(accountId: String, noteId: String){
        let endPoint = "/v1/accounts/\(accountId)/notes/\(noteId)"
        isFetchNoteDetailInProgress = true
        
        apiService.get(type: NoteDetailRespStruct.self, endpoint: endPoint){
            [weak self] result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.currentNote = results.note_detail
                    self?.isFetchNoteDetailInProgress = false
                case .failure(let error):
                    self?.isFetchNoteDetailInProgress = false
                    self?.errorMessage = error.message
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
}
