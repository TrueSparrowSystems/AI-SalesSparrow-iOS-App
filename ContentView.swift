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
    
    // The text entered by the user in the text field
    @State var text: String = ""
    
    // The calculated height of the text field based on its contents
    @State private var calculatedHeight: CGFloat = 32
    
    // The minimum and maximum height of the text field
    let minHeight: CGFloat = 32
    let maxHeight: CGFloat = 200
    
    @StateObject var loginScreenViewModel = LoginScreenViewModel()
    
    
    /// The body of the view
    var body: some View {
        VStack{
            if(!userStateViewModel.isUserLoggedIn){
//                HomeScreen()
                LoginScreen()
            }else {
                HomeScreen()
            }
        }
        .onOpenURL { incomingURL in
            handleIncomingURL(incomingURL)
        }
        .environmentObject(loginScreenViewModel)
    }
    
    
    /// Handle incoming URLs from deep links with the custom URL scheme registered in the app's Info.plist
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "salessparrow" else {
            return
        }
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
