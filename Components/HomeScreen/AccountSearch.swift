//
//  AccountSearch.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct AccountSearchView: View {
    @StateObject private var accountSearchViewModel = AccountSearchViewModel()
    @State private var searchText = ""
    
    @Binding var isPresented: Bool // This binding will control the presentation of the sheet
    
    var isCreateNoteFlow: Bool = false
    var onAccountSelected: ((Account.ID) -> Void)? // Callback function to handle account selection
    var onNoteCreateSelected: ((Account) -> Void)?  // Callback function to handle note creation selection
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search Accounts", text: $searchText)
                    .font(.custom("Nunito-Regular", size: 16).weight(.regular))
                    .foregroundColor(Color("SearchPrimary"))
                    .opacity(0.8)
            }
            .frame(height: 66)
            .padding()
            .opacity(0.6)
            .onChange(of: searchText) { newValue in
                // Call the function from the view model whenever searchText changes
                accountSearchViewModel.searchTextDidChange(newValue)
            }
            
            // Divider Line
            Divider()
                .background(Color("SearchPrimary"))
                .opacity(0.6)
            
            // List of Accounts
            List(accountSearchViewModel.listData.filter { searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText) }) { account in
                VStack() {
                    HStack{
                        Text(account.name)
                            .font(.custom("Nunito-Regular",size: 16))
                            .foregroundColor(Color("SearchPrimary"))
                        
                        Spacer()
                        
                        if !isCreateNoteFlow {
                            Text("Add Note")
                                .font(.custom("Nunito-Regular",size: 16))
                                .foregroundColor(Color("LoginButtonPrimary"))
                                .frame(width: 72.0, height: 28.0)
                                .onTapGesture {
                                    isPresented = false // Dismiss the sheet
                                    onNoteCreateSelected?(account) // Call the note creation callback function with the selected account // Call the callback function with the selected account
                                }
                        }
                    }
                    .padding(.horizontal) // Add horizontal padding to the content inside the row
                    .onTapGesture {
                        isPresented = false // Dismiss the sheet
                        if isCreateNoteFlow {
                            onNoteCreateSelected?(account) // Call the note creation callback function with the selected account // Call the callback function with the selected account
                        } else {
                            onAccountSelected?(account.id) // Call the account selection callback function with the selected account
                        }
                    }
                }
            }
            .listRowInsets(EdgeInsets())
            .listStyle(PlainListStyle())
            .onAppear {
                accountSearchViewModel.fetchData()
            }
        }
    }
}

struct CreateNoteView: View {
    @Binding var pushActive: Bool
    var accountId: Int
    var accountName: String
    
    var body: some View {
        VStack {
            Text("Create note page for \(accountName) + \(accountId)")
                .font(.custom("Nunito-Regular", size: 24))
                .fontWeight(.bold)
                .padding()
            
            // Add the rest of your content for the Create Note screen here...
        }
    }
}
