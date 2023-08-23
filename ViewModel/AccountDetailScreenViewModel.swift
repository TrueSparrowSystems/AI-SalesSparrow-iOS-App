//
//  AccountDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import Foundation
import SwiftUI
import CoreData

// A struct that represents the meta data of the note
struct Note: Identifiable, Codable {
    let id: String
    let creator: String
    let text_preview: String
    let last_modified_time: String
}

// A struct that represents the meta data of the note list API
struct NotesListStruct: Codable {
    var note_ids: [String]
    var note_map_by_id: [String: Note]
}

// A struct that represents the meta data of the note
struct Task: Identifiable, Codable {
    let id: String
    let creator_name: String
    let crm_organization_user_name: String
    let description: String
    let due_date: String
    let last_modified_time: String
}

// A struct that represents the meta data of the note list API
struct TasksListStruct: Codable {
    var task_ids: [String]
    var task_map_by_id: [String: Task]
}

struct NoteDeleteStruct: Codable {}

struct TaskDeleteStruct: Codable {}

// A class that represents the view model of account details
class AccountDetailViewScreenViewModel: ObservableObject {
    @Published var noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
    @Published var taskData = TasksListStruct(task_ids: [], task_map_by_id: [:])
    @Published var isNoteLoading = false
    @Published var isTaskLoading = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function that fetches the data for the note list
    func fetchNotes(accountId: String){
        guard !self.isNoteLoading else {
            return
        }
        self.isNoteLoading = true
        
        apiService.get(type: NotesListStruct.self, endpoint: "/v1/accounts/\(accountId)/notes"){
            [weak self]  result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.noteData.note_ids = results.note_ids
                    self?.noteData.note_map_by_id = results.note_map_by_id
                    self?.isNoteLoading = false
                case .failure(let error):
                    print("error loading data: \(error)")
                    self?.noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
                    self?.isNoteLoading = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    //A function that deletes note in an account
    func deleteNote(accountId: String, noteId: String){
        
        apiService.delete(type: NoteDeleteStruct.self, endpoint: "/v1/accounts/\(accountId)/notes/\(noteId)"){
            [weak self] result,statusCode  in
            
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.noteData.note_ids = self?.noteData.note_ids.filter(){$0 != noteId} ?? []
                    
                case .failure(let error):
                    print("error deleting note: \(error)")
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    // A function that fetches the data for the task list
    func fetchTasks(accountId: String){
        guard !self.isTaskLoading else {
            return
        }
        self.isTaskLoading = true
        
        apiService.get(type: TasksListStruct.self, endpoint: "/v1/accounts/\(accountId)/tasks"){
            [weak self]  result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.taskData.task_ids = results.task_ids
                    self?.taskData.task_map_by_id = results.task_map_by_id
                    self?.isTaskLoading = false
                case .failure(let error):
                    print("error loading data: \(error)")
                    //TODO: remove the temp code once api is deployed
                    
                    self?.taskData.task_ids = [
                        "00U1e000003TUB8EAO","00U1e000003TUB8EA1"
                    ]
                    self?.taskData.task_map_by_id = [
                        "00U1e000003TUB8EAO": Task(
                            id: "00U1e000003TUB8EAO",
                            creator_name: "xyz",
                            crm_organization_user_name: "abc",
                            description: "Complete remaining task",
                            due_date: "2019-10-12",
                            last_modified_time: "2019-10-12T07:20:50.52Z"
                        ),
                        "00U1e000003TUB8EA1": Task(
                            id: "00U1e000003TUB8EA1",
                            creator_name: "Jakob Adison",
                            crm_organization_user_name: "Zaire",
                            description: "Reach out to Romit for to set a time for the next sync with their CTO",
                            due_date: "2023-10-12",
                            last_modified_time: "2023-08-20T07:20:50.52Z"
                        )
                    ]
                    
                    //                    self?.taskData = TasksListStruct(task_ids: [], task_map_by_id: [:])
                    self?.isTaskLoading = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    //A function that deletes task in an account
    func deleteTask(accountId: String, taskId: String){
        
        apiService.delete(type: TaskDeleteStruct.self, endpoint: "/v1/accounts/\(accountId)/tasks/\(taskId)"){
            [weak self] result,statusCode  in
            
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.taskData.task_ids = self?.taskData.task_ids.filter(){$0 != taskId} ?? []
                    
                case .failure(let error):
                    print("error deleting task: \(error)")
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    // A function that resets the data for the list
    func resetData(){
        self.noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
        self.taskData = TasksListStruct(task_ids: [], task_map_by_id: [:])
    }
}
