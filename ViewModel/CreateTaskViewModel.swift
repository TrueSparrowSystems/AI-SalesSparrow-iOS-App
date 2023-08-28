//
//  CreateTaskViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 24/08/23.
//


import Foundation


struct CreateTaskStruct: Codable {
    var task_id: String
}

// A class that represents the view model of the create note
class CreateTaskViewModel: ObservableObject {
    @Published var createTaskData = TasksListStruct(task_ids: [],task_map_by_id: [:])
    
    @Published var isCreateTaskInProgress = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function to create note from given text and account id.
    func createTask(accountId: String, assignedToName: String, crmOrganizationUserId: String, description: String, dueDate: Date){
        
        guard !self.isCreateTaskInProgress else {
            return
        }
        self.isCreateTaskInProgress = true
        
        let params: [String: Any] = ["crm_organization_user_id": crmOrganizationUserId, "description": description, "due_date": BasicHelper.getDateStringFromDate(from: dueDate, dateFormat: "yyyy-MM-dd")]
        
        apiService.post(type: CreateTaskStruct.self, endpoint: "/v1/accounts/\(accountId)/tasks", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.isCreateTaskInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Task Saved and assigned to \(assignedToName)"))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error loading data: \(error)")
                    self?.isCreateTaskInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
}
