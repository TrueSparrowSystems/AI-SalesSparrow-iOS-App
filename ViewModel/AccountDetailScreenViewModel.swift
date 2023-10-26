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

// A struct that represents the meta data of the task
struct Task: Identifiable, Codable {
    let id: String
    let creator_name: String
    let crm_organization_user_name: String
    let description: String?
    let due_date: String?
    let last_modified_time: String
}

// A struct that represents the meta data of the event
struct Event: Identifiable, Codable {
    let id: String
    let creator_name: String
    let description: String?
    let start_datetime: String?
    let end_datetime: String?
    let last_modified_time: String
}

// A struct that represents the meta data of the task list API
struct TasksListStruct: Codable {
    var task_ids: [String]
    var task_map_by_id: [String: Task]
}

// A struct that represents the meta data of the event list API
struct EventsListStruct: Codable {
    var event_ids: [String]
    var event_map_by_id: [String: Event]
}

struct NoteDeleteStruct: Codable {}

struct TaskDeleteStruct: Codable {}

struct EventDeleteStruct: Codable {}

// A class that represents the view model of account details
class AccountDetailViewScreenViewModel: ObservableObject {
    @Published var noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
    @Published var taskData = TasksListStruct(task_ids: [], task_map_by_id: [:])
    @Published var eventData = EventsListStruct(event_ids: [], event_map_by_id: [:])
    @Published var isNoteListLoading = false
    @Published var isTaskListLoading = false
    @Published var isEventListLoading = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function that fetches the data for the note list
    func fetchNotes(accountId: String) {
        guard !self.isNoteListLoading else {
            return
        }
        self.isNoteListLoading = true
        
        apiService.get(type: NotesListStruct.self, endpoint: "/v1/accounts/\(accountId)/notes") {
            [weak self]  result, _ in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.noteData.note_ids = results.note_ids
                    self?.noteData.note_map_by_id = results.note_map_by_id
                    self?.isNoteListLoading = false
                case .failure(let error):
                    print("error loading data: \(error)")
                    self?.noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
                    self?.isNoteListLoading = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    // A function that deletes note in an account
    func deleteNote(accountId: String, noteId: String) {
        
        LoaderViewModel.shared.showLoader()
        apiService.delete(type: NoteDeleteStruct.self, endpoint: "/v1/accounts/\(accountId)/notes/\(noteId)") {
            [weak self] result, _  in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.noteData.note_ids = self?.noteData.note_ids.filter {$0 != noteId} ?? []
                    
                case .failure(let error):
                    print("error deleting note: \(error)")
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
                LoaderViewModel.shared.hideLoader()
            }
        }
    }
    
    // A function that fetches the data for the task list
    func fetchTasks(accountId: String) {
        guard !self.isTaskListLoading else {
            return
        }
        self.isTaskListLoading = true
        
        apiService.get(type: TasksListStruct.self, endpoint: "/v1/accounts/\(accountId)/tasks") {
            [weak self]  result, _ in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.taskData.task_ids = results.task_ids
                    self?.taskData.task_map_by_id = results.task_map_by_id
                    self?.isTaskListLoading = false
                case .failure(let error):
                    print("error loading data: \(error)")
                    self?.taskData = TasksListStruct(task_ids: [], task_map_by_id: [:])
                    self?.isTaskListLoading = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    // A function that deletes task in an account
    func deleteTask(accountId: String, taskId: String, onSuccess: @escaping() -> Void) {
        
        LoaderViewModel.shared.showLoader()
        apiService.delete(type: TaskDeleteStruct.self, endpoint: "/v1/accounts/\(accountId)/tasks/\(taskId)") {
            [weak self] result, _  in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    onSuccess()
                    self?.taskData.task_ids = self?.taskData.task_ids.filter {$0 != taskId} ?? []
                    
                case .failure(let error):
                    print("error deleting task: \(error)")
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
                LoaderViewModel.shared.hideLoader()
            }
        }
    }
    
    // A function that fetches the data for the event list
    func fetchEvents(accountId: String) {
        guard !self.isEventListLoading else {
            return
        }
        self.isEventListLoading = true
        
        apiService.get(type: EventsListStruct.self, endpoint: "/v1/accounts/\(accountId)/events") {
            [weak self]  result, _ in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.eventData.event_ids = results.event_ids
                    self?.eventData.event_map_by_id = results.event_map_by_id
                    self?.isEventListLoading = false
                case .failure(let error):
                    print("error loading data: \(error)")
                    self?.eventData = EventsListStruct(event_ids: [], event_map_by_id: [:])
                    self?.isEventListLoading = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    // A function that deletes event in an account
    func deleteEvent(accountId: String, eventId: String, onSuccess: @escaping() -> Void) {
        
        LoaderViewModel.shared.showLoader()
        apiService.delete(type: EventDeleteStruct.self, endpoint: "/v1/accounts/\(accountId)/events/\(eventId)") {
            [weak self] result, _  in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    onSuccess()
                    self?.eventData.event_ids = self?.eventData.event_ids.filter {$0 != eventId} ?? []
                    
                case .failure(let error):
                    print("error deleting event: \(error)")
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
                LoaderViewModel.shared.hideLoader()
            }
        }
    }
    
    // A function that resets the data for the list
    func resetData() {
        self.noteData = NotesListStruct(note_ids: [], note_map_by_id: [:])
        self.taskData = TasksListStruct(task_ids: [], task_map_by_id: [:])
        self.eventData = EventsListStruct(event_ids: [], event_map_by_id: [:])
    }
}
