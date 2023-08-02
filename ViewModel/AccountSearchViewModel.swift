//
//  AccountSearchViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import Foundation

struct Account: Identifiable {
    let id: Int
    let name: String
}

class SearchAccountViewModel: ObservableObject {
    @Published var listData: [Account] = []
    @Published var isLoadingPage = false

    // A function that fetches the data for the list
    func fetchData() {
        guard !self.isLoadingPage else { return }
        self.isLoadingPage = true

        // Simulate asynchronous data fetching with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listData = [
                Account(id: 100, name: "Amagic"),
                Account(id: 200, name: "Dunlo"),
                Account(id: 300, name: "Duplo"),
                Account(id: 400, name: "E-Service"),
                Account(id: 500, name: "Fab"),
                Account(id: 600, name: "GoCark"),
                Account(id: 700, name: "Hem"),
                Account(id: 800, name: "Jam"),
                Account(id: 900, name: "Smagic"),
                Account(id: 1000, name: "Facebook"),
                Account(id: 1100, name: "Uber"),
                Account(id: 1200, name: "Microsoft"),
                Account(id: 1300, name: "Apple"),
                Account(id: 1400, name: "Google"),
                Account(id: 1500, name: "Amazon"),
                Account(id: 1600, name: "Netflix"),
                Account(id: 1700, name: "Tesla"),
                Account(id: 1800, name: "Twitter"),
                Account(id: 1900, name: "Instagram"),
                Account(id: 2000, name: "LinkedIn"),
                Account(id: 2100, name: "Snapchat"),
                Account(id: 2200, name: "Adobe"),
                Account(id: 2300, name: "Salesforce"),
                Account(id: 2400, name: "Zoom"),
                Account(id: 2500, name: "Oracle"),
                Account(id: 2600, name: "IBM"),
                Account(id: 2700, name: "Intel"),
                Account(id: 2800, name: "HP"),
                Account(id: 2900, name: "Dell"),
                Account(id: 3000, name: "Samsung"),
                Account(id: 3100, name: "Sony"),
                Account(id: 3200, name: "LG"),
                Account(id: 3300, name: "Toyota"),
                Account(id: 3400, name: "Honda"),
                Account(id: 3500, name: "BMW"),
                Account(id: 3600, name: "Mercedes-Benz"),
                Account(id: 3700, name: "Coca-Cola"),
                Account(id: 3800, name: "Pepsi"),
                Account(id: 3900, name: "Nike"),
                Account(id: 4000, name: "Adidas"),
                Account(id: 4100, name: "McDonald's"),
                Account(id: 4200, name: "Starbucks"),
                Account(id: 4300, name: "Walmart"),
                Account(id: 4400, name: "Amazon"),
                Account(id: 4500, name: "IBM"),
                Account(id: 4600, name: "Microsoft"),
                Account(id: 4700, name: "Intel"),
                Account(id: 4800, name: "Google"),
                Account(id: 4900, name: "Facebook")
            ]
            
            self.isLoadingPage = false
        }
    }

    // A function that resets the data for the list
    func resetData() {
        self.listData.removeAll()
    }
}

