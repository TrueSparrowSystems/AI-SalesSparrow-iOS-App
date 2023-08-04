//
//  SalesSparrowApp.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

@main
struct SalesSparrowApp: App {
    
    // The Core Data context for the app
    let persistenceController = PersistenceController.shared
    var environments: () = Environments.shared.setTarget(target: BuildTarget.production)
    @StateObject var userStateViewModel = UserStateViewModel.shared
    
    
    // The app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let isRunningUITests = ProcessInfo.processInfo.arguments.contains("isRunningUITests")
        DependencyContainer.shared.setApiService(isRunningUITests: isRunningUITests)
    }
    
    
    // The main view of the app
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(Environments.shared)
                .environmentObject(userStateViewModel)
        }
    }
}

class DependencyContainer: ObservableObject {
    static let shared = DependencyContainer()
    var apiService: ApiService = ApiService()
    
    private init() {}
    
    func setApiService(isRunningUITests: Bool = false) {
        apiService = isRunningUITests ? MockAPIService() : ApiService()
    }
}
