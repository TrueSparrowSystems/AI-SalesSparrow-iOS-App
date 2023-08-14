//
//  ContentView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI
import CoreData

/// The main view of the app,
struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    @EnvironmentObject var environment: Environments
    
    @StateObject var loginScreenViewModel = LoginScreenViewModel()
    @StateObject var toastViewModel = ToastViewModel.shared
    
    /// The body of the view
    var body: some View {
        VStack{
            if(!userStateViewModel.isUserLoggedIn){
                LoginScreen()
            }else {
                HomeScreen()
            }
        }
        .onOpenURL { incomingURL in
            handleIncomingURL(incomingURL)
        }
        .environmentObject(loginScreenViewModel)
        .toastView(toast: $toastViewModel.toast)
    }
    
    
    /// Handle incoming URLs from deep links with the custom URL scheme registered in the app's Info.plist
    private func handleIncomingURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            
            return
        }
        let authToken = components.queryItems?.first(where: { $0.name == "code" })?.value
        
        if((authToken) != nil){
            environment.setAuthToken(authToken: authToken ?? "")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
