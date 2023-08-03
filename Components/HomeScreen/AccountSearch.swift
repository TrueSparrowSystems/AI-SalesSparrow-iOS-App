//
//  AccountSearch.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct AccountSearchView: View {
    @StateObject private var viewModel = SearchAccountViewModel()
    @State private var searchText = ""
    var forAccountSearch: Bool = false
    
    @Binding var isPresented: Bool // This binding will control the presentation of the sheet
    var onAccountSelected: ((Account, Bool) -> Void)? // Callback function to handle account selection
    
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
            
            // Divider Line
            Divider()
                .background(Color("SearchPrimary"))
                .opacity(0.6)
            
            // List of Accounts
            List(viewModel.listData.filter { searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText) }) { account in
                VStack() {
                    HStack{
                        Text(account.name)
                            .font(.custom("Nunito-Regular",size: 16))
                            .foregroundColor(Color("SearchPrimary"))
                        
                        Spacer()
                        if forAccountSearch {
                            Text("Add Note")
                                .font(.custom("Nunito-Regular",size: 16))
                                .foregroundColor(Color("LoginButtonPrimary"))
                                .frame(width: 72.0, height: 28.0)
                                .onTapGesture {
                                    isPresented = false // Dismiss the sheet
                                    onAccountSelected?(account, true) // Call the callback function with the selected account
                                }
                        }
                    }
                    .onTapGesture {
                        isPresented = false // Dismiss the sheet
                        onAccountSelected?(account, false) // Call the callback function with the selected account
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct CreateNoteView: View {
    var account: Account?
    
    var body: some View {
        VStack {
            Text("Account Details page for \(account?.name ?? " ")")
                .font(.custom("Nunito-Regular", size: 24))
                .fontWeight(.bold)
                .padding()
            
            // Add the rest of your content for the Create Note screen here...
        }
    }
}
