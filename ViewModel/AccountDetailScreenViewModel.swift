//
//  AccountDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import Foundation
import SwiftUI
import CoreData

struct Note: Identifiable, Codable {
    let id: String
    let creator: String
    let text_preview: String
    let last_modified_time: String
}

struct NotesListStruct: Codable {
    var note_ids: [String]
    var note_map_by_id: [String: Note]
}

// A class that represents the view model of the list
class AccountDetailViewScreenViewModel: ObservableObject {
    @Published var noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
    @Published var isLoading = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function that fetches the data for the list
    func fetchNotes(accountId: String){
        guard !self.isLoading else {
            return
        }
        self.isLoading = true
        
        apiService.get(type: NotesListStruct.self, endpoint: "/v1/accounts/\(accountId)/notes"){
            [weak self]  result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.noteData.note_ids = results.note_ids
                    self?.noteData.note_map_by_id = results.note_map_by_id
                    self?.isLoading = false
                case .failure(let error):
                    print("error loading data: \(error)")
                    self?.noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
                    self?.isLoading = false
                }
            }
        }
    }
    
    // A function that resets the data for the list
    func resetData(){
        self.noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
    }
}
