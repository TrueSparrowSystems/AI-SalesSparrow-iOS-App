//
//  CreateEventViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 13/09/23.
//

import Foundation

struct CreateEventStruct: Codable {
    var event_id: String
}

// A class that represents the view model of the create note
class CreateEventViewModel: ObservableObject {
    @Published var createEventData = EventsListStruct(event_ids: [],event_map_by_id: [:])
    
    @Published var isCreateEventInProgress = false
    var apiService = DependencyContainer.shared.apiService
    
    // A function to create note from given text and account id.
    func createEvent(accountId: String, description: String, startDate: Date, startTime: Date, endDate: Date, endTime: Date, onSuccess : @escaping(String)-> Void, onFailure: (()-> Void)?){
        
        guard !self.isCreateEventInProgress else {
            return
        }
        self.isCreateEventInProgress = true
        
        let params: [String: Any] = ["description": description, "start_datetime": BasicHelper.getFormattedDateTimeString(from: startDate, from: startTime), "end_datetime": BasicHelper.getFormattedDateTimeString(from: endDate, from: endTime)]
        
        apiService.post(type: CreateEventStruct.self, endpoint: "/v1/accounts/\(accountId)/events", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    onSuccess(results.event_id)
                    self?.isCreateEventInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Event Saved"))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure?()
                    print("error loading data: \(error)")
                    self?.isCreateEventInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
}
