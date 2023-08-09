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
            
            NotesListComp()
            
            HStack {
                Text("Pushed the view into the stack with AccountID - \(accountId)----\(accountName)")
            }
            
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

struct AccountDetailsHeaderComp: View {
    var accountId: String
    var accountName: String
    
    var body: some View {
        HStack{
            Image("Buildings")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25.0, height: 25.0)
            
            Text("Account Details")
            
            Spacer()
        }
        VStack(spacing: 5) {
            HStack {
                Text("ACCOUNT")
                    .font(.custom("Nunito-Regular",size: 14))
                Spacer()
            }
            HStack {
                Text(accountName)
                    .font(.custom("Nunito-Regular",size: 22))
                Spacer()
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(5) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

struct NotesListComp: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack{
                Image("NoteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                
                Text("Notes")
                
                Spacer()
                
                Image("CreateNoteIcon")
                    .frame(width: 20.0, height: 20.0)
            }
            VStack(spacing: 5) {
                HStack {
                    Spacer()
                    Text("Add notes and sync with your salesforce account")
                        .font(.custom("Nunito-Regular",size: 12))
                    Spacer()
                }
            }
            .padding()
            .cornerRadius(5) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                //                    .stroke(Color("BorderColor"), lineWidth: 1)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1,5]))
            )
        }
    }
}
