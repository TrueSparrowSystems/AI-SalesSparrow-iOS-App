//
//  AccountDetailsScreen.swift
//  SalesSparrow
//
//  Created by Alpesh Modi on 09/08/23.
//

import SwiftUI

struct AccountDetailsScreen: View {
    var accountId: String
    var accountName: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 20) {
            
            AccountDetailsHeaderComp(accountId: accountId, accountName: accountName)
            
            // Contact list component
            
            NotesListComp(accountId: accountId, accountName: accountName)
            
            Spacer()
        }
        .padding()
        .background(Color("Background"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: {
            // This will dismiss the AccountDetailsScreen and go back to the previous view
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Details")
            }
            .foregroundColor(Color("SaveButtonBackground"))
        }
    }
}

