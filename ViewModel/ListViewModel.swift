//
//  ListViewModel.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation
import SwiftUI
import CoreData

// A struct that represents the meta data of the list
struct ListStruct: Codable {
    var ids_array: [String]
    var meta: Meta?
}

// A class that represents the view model of the list
class ListViewModel: ObservableObject {
    @Published var listData = ListStruct(ids_array: [], meta: nil)
    @Published var isLoadingPage = false
    
    // A function that fetches the data for the list
    func fetchData() {
        guard !self.isLoadingPage else { return }
        self.isLoadingPage = true
            
     
        let apiParams: [String: Any] = [:]

        // If the list is not empty and the pagination identifier is nil then return as there is no more data to fetch
        if(self.listData.ids_array.count > 0 && apiParams["pagination_identifier"] == nil) {
              self.isLoadingPage = false
              return
        }
        
        // Fetch the data from the API
        ApiService().get(type: ListStruct.self, endpoint: "/listData/search", params: apiParams) { [weak self]  result, statusCode in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { //should be never used
                switch result {
                case .success(let results):
                    DispatchQueue.main.async {
                        let ids_array = (self?.listData.ids_array ?? []) + results.ids_array
                        let orderedSet = NSOrderedSet(array:ids_array)
                        self?.listData.ids_array = orderedSet.array as! [String]
                        self?.listData.meta = results.meta
                        self?.isLoadingPage = false
                    }

                case .failure(let error):
                        print("error loading data: \(error)")
                }
            }
        }
    }

    // A function that resets the data for the list
     func resetData(){
        self.listData = ListStruct(ids_array: [], meta: nil)
    }

}
