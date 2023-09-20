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

// A struct that represents the meta data of the task suggestion entity
struct TaskSuggestionStruct: Codable, Equatable {
    var id: String?
    var description: String
    var due_date: String?
}

// A struct that represents the meta data of the event suggestion entity
struct EventSuggestionStruct: Codable, Equatable {
    var id: String?
    var description: String
    var start_datetime: String?
    var end_datetime: String?
}

// A struct that represents the meta data of the generate suggested task API
struct GenerateSuggestionStruct: Codable, Equatable {
    var add_task_suggestions: [TaskSuggestionStruct]
}

// A class that represents the view model of the create note
class CreateNoteScreenViewModel: ObservableObject {
    @Published var createNoteData = CreateNoteStruct(note_id: "")
    @Published var suggestedTaskData = GenerateSuggestionStruct(add_task_suggestions: [])
    @Published var isCreateNoteInProgress = false
    @Published var isSuggestionGenerationInProgress = false
    @Published var suggestedTaskStates : [String: [String: Any]]  = [:]
    @Published var suggestedEventStates : [String: [String: Any]]  = [:]
    var apiService = DependencyContainer.shared.apiService
    
    func initTaskData(suggestion: TaskSuggestionStruct){
        var dueDate: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format of your due_date
        if let date = dateFormatter.date(from: suggestion.due_date ?? "") {
            dueDate =  date
        } else {
            dueDate = Date()
        }
        suggestedTaskStates[suggestion.id ?? ""] = [
            "description": suggestion.description,
            "dueDate": dueDate,
            "assignedToUsername": "",
            "selectedUserId": "",
            "isDateSelected": suggestion.due_date?.isEmpty ?? true ?  false : true,
            "isTaskSaved": false,
        ]
    }
    
    func initEventData(suggestion: EventSuggestionStruct){
        var startDate: Date
        var startTime: Date
        var endDate: Date
        var endTime: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format of your due_date
        if let date = dateFormatter.date(from: suggestion.start_datetime ?? "") {
            startDate =  date
            startTime =  date
        } else {
            startDate = Date()
            startTime = Date()
        }
        if let date = dateFormatter.date(from: suggestion.end_datetime ?? "") {
            endDate =  date
            endTime =  date
        } else {
            endDate = Date()
            endTime = Date()
        }
        suggestedEventStates[suggestion.id ?? ""] = [
            "description": suggestion.description,
            "startDate": startDate,
            "startTime": startTime,
            "endDate": endDate,
            "endTime": endTime,
            "isStartDateSelected": suggestion.start_datetime?.isEmpty ?? true ? false : true,
            "isStartTimeSelected": suggestion.start_datetime?.isEmpty ?? true ? false : true,
            "isEndDateSelected": suggestion.end_datetime?.isEmpty ?? true ? false : true,
            "isEndTimeSelected": suggestion.end_datetime?.isEmpty ?? true ? false : true,
            "isEventSaved": false,
        ]
    }
    
    func setTaskDataAttribute(id: String, attrKey: String, attrValue: Any){
        if(suggestedTaskStates[id] == nil){
            suggestedTaskStates[id] = [:]
        }
        suggestedTaskStates[id]?[attrKey] = attrValue
        
    }
    
    func setEventDataAttribute(id: String, attrKey: String, attrValue: Any){
        if(suggestedEventStates[id] == nil){
            suggestedEventStates[id] = [:]
        }
        suggestedEventStates[id]?[attrKey] = attrValue
        
    }
    
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
                    for index in 0..<results.add_task_suggestions.count{
                        
                        self?.suggestedTaskData.add_task_suggestions[index].id = UUID().uuidString
                        let suggestion = self?.suggestedTaskData.add_task_suggestions[index]
                        self?.initTaskData(suggestion: suggestion ?? TaskSuggestionStruct(description: ""))
                    }
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
