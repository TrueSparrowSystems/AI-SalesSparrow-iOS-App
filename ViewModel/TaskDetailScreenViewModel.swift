//
//  TaskDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 22/09/23.
//

import Foundation

// A struct that represents the meta data of the note details API
struct TaskDetailRespStruct: Codable {
    var task_detail: TaskDetailStruct
}

// A struct that represents the meta data of the note details
struct TaskDetailStruct: Equatable, Codable {
    var id: String
    var creator: String
    var crm_organization_user_id: String
    var crm_organization_user_name: String
    var description: String
    var due_date: String
    var last_modified_time: String
}

struct EditTaskRespStruct: Codable {
}

// A class that represents the view model of the create note
class TaskDetailScreenViewModel: ObservableObject {
    @Published var currentTaskData = TaskDetailStruct(id: "", creator: "", crm_organization_user_id: "", crm_organization_user_name: "", description: "", due_date: "", last_modified_time: "")
    @Published var isFetchTaskInProgress = false
    @Published var isSaveTaskInProgress = false
    var errorMessage: String = ""
    var apiService = DependencyContainer.shared.apiService
    
    // A function to create note from given text and account id.
    func fetchTaskDetail(accountId: String, taskId: String){
        let endPoint = "/v1/accounts/\(accountId)/tasks/\(taskId)"
        isFetchTaskInProgress = true
        
        apiService.get(type: TaskDetailRespStruct.self, endpoint: endPoint){
            [weak self] result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.currentTaskData = results.task_detail
                    self?.isFetchTaskInProgress = false
                case .failure(let error):
                    self?.isFetchTaskInProgress = false
                    self?.errorMessage = error.message
                    self?.currentTaskData = TaskDetailStruct(
                        id: "your_mock_task_id",
                        creator: "your_mock_creator",
                        crm_organization_user_id: "your_mock_crm_user_id",
                        crm_organization_user_name: "your mock_crm_user_name",
                        description: "Your mock task description",
                        due_date: "2028-01-31", // Mock due date
                        last_modified_time: "2023-09-22T10:30:00.00Z" // Mock last modified time
                    )
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    func EditTaskDetail(accountId: String, taskId: String, crm_organization_user_id: String, description: String, due_date: String, onSuccess : @escaping()-> Void){
        let endPoint = "/v1/accounts/\(accountId)/tasks/\(taskId)"
        isSaveTaskInProgress = true
        
        let params: [String: Any] = ["crm_organization_user_id": crm_organization_user_id,
                                     "description": description,
                                     "due_date": due_date]
        
        apiService.put(type: EditNoteRespStruct.self, endpoint: endPoint, params: params){
            [weak self] result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    onSuccess()
                    self?.isSaveTaskInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Task is saved to your Salesforce Account"))
                    
                case .failure(let error):
                    self?.isSaveTaskInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
}

