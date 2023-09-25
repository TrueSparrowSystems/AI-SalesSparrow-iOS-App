//
//  EventDetailScreenViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 25/09/23.
//

import Foundation

// A struct that represents the meta data of the note details API
struct EventDetailRespStruct: Codable {
    var event_detail: EventDetailStruct
}

// A struct that represents the meta data of the note details
struct EventDetailStruct: Equatable, Codable {
    var id: String
    var creator: String
    var description: String
    var start_datetime: String
    var end_datetime: String
    var last_modified_time: String
}

struct EditEventRespStruct: Codable {
}

// A class that represents the view model of the create note
class EventDetailScreenViewModel: ObservableObject {
    @Published var currentEventData = EventDetailStruct(id: "", creator: "", description: "", start_datetime: "", end_datetime: "", last_modified_time: "")
    
    @Published var isFetchEventInProgress = false
    @Published var iseditEventInProgress = false
    var errorMessage: String = ""
    var apiService = DependencyContainer.shared.apiService
    
    // A function to create note from given text and account id.
    func fetchEventDetail(accountId: String, eventId: String, onSuccess : @escaping(String)-> Void, onFailure: (()-> Void)?){
        let endPoint = "/v1/accounts/\(accountId)/events/\(eventId)"
        guard !self.isFetchEventInProgress else {
            return
        }
        
        isFetchEventInProgress = true
        
        apiService.get(type: EventDetailRespStruct.self, endpoint: endPoint){
            [weak self] result, statusCode in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.errorMessage = ""
                    self?.currentEventData = results.event_detail
                    self?.isFetchEventInProgress = false
                case .failure(let error):
                    self?.isFetchEventInProgress = false
                    self?.errorMessage = error.message
                    self?.currentEventData = EventDetailStruct(
                        id: "your_mock_task_id",
                        creator: "your_mock_creator",
                        description: "Your mock Event description",
                        start_datetime: "2023-01-19T11:30:00.00Z",
                        end_datetime: "2023-12-08T04:30:00.00Z",
                        last_modified_time: "2023-09-22T10:30:00.00Z"
                    )
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
        }
    }
    
    func editEvent(accountId: String, description: String, startDate: Date, startTime: Date, endDate: Date, endTime: Date, onSuccess : @escaping(String)-> Void, onFailure: (()-> Void)?){
        
        guard !self.iseditEventInProgress else {
            return
        }
        self.iseditEventInProgress = true
        let startDateTime = BasicHelper.getFormattedDateTimeString(from: startDate, from: startTime)
        let endDateTime = BasicHelper.getFormattedDateTimeString(from: endDate, from: endTime)
        
        if(endDateTime < startDateTime){
            onFailure?()
            self.iseditEventInProgress = false
            ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: "End Time cannot be shorter than or equal to Start Time"))
            return
        } else{
            let fourteenDaysFromStartDateTime = BasicHelper.getFormattedDateTimeString(from: Calendar.current.date(byAdding: .day, value: 14, to: startDate)!, from: startTime)
            if(endDateTime > fourteenDaysFromStartDateTime ){
                onFailure?()
                self.iseditEventInProgress = false
                ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: "An event can't last longer than 14 days."))
                return
            }
        }
        
        let params: [String: Any] = ["description": description, "start_datetime": startDateTime, "end_datetime": endDateTime]
        
        
        apiService.put(type: CreateEventStruct.self, endpoint: "/v1/accounts/\(accountId)/events", params: params){
            [weak self]  result, statusCode in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    onSuccess(results.event_id)
                    self?.iseditEventInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Event Updated."))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    onFailure?()
                    print("error loading data: \(error)")
                    self?.iseditEventInProgress = false
                    ToastViewModel.shared.showToast(_toast: Toast(style: .error, message: error.message))
                }
            }
            
        }
    }
}
