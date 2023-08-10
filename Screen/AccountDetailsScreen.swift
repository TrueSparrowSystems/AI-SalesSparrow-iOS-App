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
        ScrollView{
            VStack(spacing: 20) {
                
                AccountDetailsHeader(accountId: accountId, accountName: accountName)
                
                // Contact list component
                
                NotesList(accountId: accountId, accountName: accountName)
                
                Spacer()
            }
        }
        .padding(.vertical)
        .padding(.leading)
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

