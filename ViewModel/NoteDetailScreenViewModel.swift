//
//  NoteDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 11/08/23.
//

import Foundation

struct NoteDetailRespStruct: Codable {
    var note_detail: NoteDetailStruct
}

struct NoteDetailStruct : Codable {
    var id: String
    var creator: String
    var text: String
    var last_modified_time: String
}

class NoteDetailScreenViewModel: ObservableObject {
    @Published var noteDetail = NoteDetailStruct(id: "", creator: "", text: "", last_modified_time: "")
    @Published var isFetchNoteDetailInProgress = false
    @Published var errorMessage = ""
    var apiService = DependencyContainer.shared.apiService
    
    func fetchNoteDetail(accountId: String, noteId: String){
        let endPoint = "/v1/accounts/\(accountId)/notes/\(noteId)"
        isFetchNoteDetailInProgress = true
        
        apiService.get(type: NoteDetailRespStruct.self, endpoint: endPoint){
            [weak self] result, statusCode in
            
            //TODO: remove once api is integrated
            self?.noteDetail = NoteDetailStruct(id: noteId, creator: "A", text: "Note Full Content", last_modified_time: "2019-10-12T07:20:50.52Z")
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.isFetchNoteDetailInProgress = false
                    self?.noteDetail = results.note_detail
                case .failure(let error):
                    self?.isFetchNoteDetailInProgress = false
                    //TODO: uncomment this line once api is integrated
                    //                    self?.errorMessage = error.message
                    
                }
            }
        }
    }
    
}
