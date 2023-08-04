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
    let environment = Environments(target: BuildTarget.production)
    @StateObject var userStateViewModel = UserStateViewModel()
    
    
    // The app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // The main view of the app
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(environment)
                .environmentObject(userStateViewModel)
        }
    }
}
