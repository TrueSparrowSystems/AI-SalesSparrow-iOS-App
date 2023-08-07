//
//  AccountSearchViewModel.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import Foundation

struct Account: Identifiable, Codable {
    let id: String
    let name: String
}

class AccountSearchViewModel: ObservableObject {
    @Published var listData: [Account] = []
    @Published var isLoadingPage = false
    
    // A function that fetches the data for the list
    func fetchData() {
        guard !self.isLoadingPage else { return }
        self.isLoadingPage = true
        
        // Simulate asynchronous data fetching with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listData = [
                Account(id: "100", name: "Amagic"),
                Account(id: "200", name: "Dunlo"),
                Account(id: "300", name: "Duplo"),
                Account(id: "400", name: "E-Service"),
                Account(id: "500", name: "Fab"),
                Account(id: "600", name: "GoCark"),
                Account(id: "700", name: "Hem"),
                Account(id: "800", name: "Jam"),
                Account(id: "900", name: "Smagic"),
                Account(id: "1000", name: "Facebook"),
                Account(id: "1100", name: "Uber"),
                Account(id: "1200", name: "Microsoft"),
                Account(id: "1300", name: "Apple"),
                Account(id: "1400", name: "Google"),
                Account(id: "1500", name: "Amazon"),
                Account(id: "1600", name: "Netflix"),
                Account(id: "1700", name: "Tesla"),
                Account(id: "1800", name: "Twitter"),
                Account(id: "1900", name: "Instagram"),
                Account(id: "2000", name: "LinkedIn"),
                Account(id: "2100", name: "Snapchat"),
                Account(id: "2200", name: "Adobe"),
                Account(id: "2300", name: "Salesforce"),
                Account(id: "2400", name: "Zoom"),
                Account(id: "2500", name: "Oracle"),
                Account(id: "2600", name: "IBM"),
                Account(id: "2700", name: "Intel"),
                Account(id: "2800", name: "HP"),
                Account(id: "2900", name: "Dell"),
                Account(id: "3000", name: "Samsung"),
                Account(id: "3100", name: "Sony"),
                Account(id: "3200", name: "LG"),
                Account(id: "3300", name: "Toyota"),
                Account(id: "3400", name: "Honda"),
                Account(id: "3500", name: "BMW"),
                Account(id: "3600", name: "Mercedes-Benz"),
                Account(id: "3700", name: "Coca-Cola"),
                Account(id: "3800", name: "Pepsi"),
                Account(id: "3900", name: "Nike"),
                Account(id: "4000", name: "Adidas"),
                Account(id: "4100", name: "McDonald's"),
                Account(id: "4200", name: "Starbucks"),
                Account(id: "4300", name: "Walmart"),
                Account(id: "4400", name: "Amazon"),
                Account(id: "4500", name: "IBM"),
                Account(id: "4600", name: "Microsoft"),
                Account(id: "4700", name: "Intel"),
                Account(id: "4800", name: "Google"),
                Account(id: "4900", name: "Facebook")
            ]
            
            self.isLoadingPage = false
        }
    }

    // A function that resets the data for the list
    func resetData() {
        self.listData.removeAll()
    }
    
    // A function that handles search text changes and triggers an API call for search
    func searchTextDidChange(_ searchText: String) {
        // Filter the list based on the search text
        if searchText.isEmpty {
//            resetData() // If search text is empty, reset the list to show all accounts
        } else {
            searchAccounts(withText: searchText)
        }
    }
    
    private func searchAccounts(withText searchText: String) {
        // Perform the API call for searching accounts
        let searchUrl = "/api/v1/accounts"
        let params: [String: Any] = ["q": searchText]

        ApiService().get(type: [Account].self, endpoint: searchUrl, params: params) { [weak self] result, statusCode in
            switch result {
            case .success(let accounts):
                DispatchQueue.main.async {
                    self?.listData = accounts
                }
                
            case .failure(let error):
                self?.listData = [
                    Account(id: "100", name: "Acme Corp"),
                    Account(id: "200", name: "Tech Solutions Inc"),
                    Account(id: "300", name: "Global Enterprises"),
                    Account(id: "400", name: "Innovative Labs"),
                    Account(id: "500", name: "Alpha Services"),
                    Account(id: "600", name: "Dynamic Systems"),
                    Account(id: "700", name: "Pioneer Tech"),
                    Account(id: "800", name: "Swift Innovations"),
                    Account(id: "900", name: "Fusion Technologies"),
                    Account(id: "1000", name: "Apex Solutions"),
                    Account(id: "1100", name: "Vanguard Inc"),
                    Account(id: "1200", name: "Eagle Enterprises"),
                    Account(id: "1300", name: "Matrix Corp"),
                    Account(id: "1400", name: "Horizon Systems"),
                    Account(id: "1500", name: "Orbit Technologies"),
                    Account(id: "1600", name: "Stellar Services"),
                    Account(id: "1700", name: "Venture Labs"),
                    Account(id: "1800", name: "Infinite Innovations"),
                    Account(id: "1900", name: "Nexa Solutions"),
                    Account(id: "2000", name: "Futura Enterprises"),
                    Account(id: "2100", name: "Synergy Tech"),
                    Account(id: "2200", name: "Nova Systems"),
                    Account(id: "2300", name: "Horizon Labs"),
                    Account(id: "2400", name: "Equinox Technologies"),
                    Account(id: "2500", name: "Galaxy Innovations"),
                    Account(id: "2600", name: "Voyager Corp"),
                    Account(id: "2700", name: "Eclipse Services"),
                    Account(id: "2800", name: "Innova Solutions"),
                    Account(id: "2900", name: "Apex Enterprises"),
                    Account(id: "3000", name: "Swift Labs")
                ]
                print("Error loading data: \(error)")
                // Handle error if needed
            }
        }
    }
}

