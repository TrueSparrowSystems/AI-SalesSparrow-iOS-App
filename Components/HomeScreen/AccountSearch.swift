//
//  AccountSearch.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct AccountSearchView: View {
    @EnvironmentObject var accountSearchViewModel: AccountSearchViewModel
    @State private var searchText = ""
    
    @Binding var isPresented: Bool // This binding will control the presentation of the sheet
    
    var isCreateNoteFlow: Bool = false
    var onAccountSelected: ((String, String) -> Void)? // Callback function to handle account selection
    var onNoteCreateSelected: ((String,String) -> Void)?  // Callback function to handle note creation selection
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search Accounts", text: $searchText)
                    .font(.custom("Nunito-Regular", size: 16).weight(.regular))
                    .foregroundColor(Color("SearchPrimary"))
                    .accessibilityIdentifier("text_field_search_account")
                    .opacity(0.8)
            }
            .frame(height: 66)
            .padding(.horizontal)
            .opacity(0.6)
            .onChange(of: searchText) { newValue in
                // Call the function from the view model whenever searchText changes
                accountSearchViewModel.fetchData(newValue)
            }
            
            // Divider Line
            Divider()
                .background(Color("SearchPrimary"))
                .opacity(0.6)
            
            if(accountSearchViewModel.isSearchAccountInProgress){
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            else if(accountSearchViewModel.accountListData.account_ids.count > 0){
                // List of Accounts
                AccountListView(
                    listData: accountSearchViewModel.accountListData,
                    accountIds: accountSearchViewModel.accountListData.account_ids,
                    isCreateNoteFlow: isCreateNoteFlow,
                    onNoteCreateSelected: onNoteCreateSelected,
                    onAccountSelected: onAccountSelected,
                    isPresented: $isPresented
                )
            }
            else{
                Text("No Result Found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onAppear {
            accountSearchViewModel.fetchData("")
        }
        .background(Color("Background"))
    }
}

struct AccountListView: View {
    var listData: SearchAccountStruct
    var accountIds: [String]
    var isCreateNoteFlow: Bool
    var onNoteCreateSelected: ((String, String) -> Void)?
    var onAccountSelected: ((String, String) -> Void)?
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                ForEach(accountIds, id: \.self) { accountId in
                    if let account = listData.account_map_by_id[accountId] {
                        HStack (alignment: .center) {
                            HStack {
                                Text(account.name)
                                    .font(.custom("Nunito-Regular", size: 16))
                                    .foregroundColor(Color("SearchPrimary"))
                                Spacer()
                            }
                            .border(Color("Background"))
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier("btn_search_account_name_\(account.name)")
                            .onTapGesture {
                                isPresented = false // Dismiss the sheet
                                if isCreateNoteFlow {
                                    onNoteCreateSelected?(accountId, account.name)
                                } else {
                                    onAccountSelected?(accountId, account.name)
                                }
                            }
                            
                            if !isCreateNoteFlow {
                                HStack {
                                    Button(action: {
                                        isPresented = false // Dismiss the sheet
                                        onNoteCreateSelected?(accountId, account.name)
                                    }) {
                                        Text("Add Note")
                                            .font(.custom("Nunito-Regular", size: 16))
                                            .foregroundColor(Color("LoginButtonPrimary"))
                                    }
                                    .accessibilityIdentifier("btn_search_add_note_\(account.name)")
                                    
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                        // Divider Line
                        Divider()
                            .background(Color("SearchPrimary"))
                            .opacity(0.6)
                        
                    }
                }
            }
        }
    }
}


//
//struct CreateNoteView: View {
//    @Binding var pushActive: Bool
//    var accountId: Int
//    var accountName: String
//
//    var body: some View {
//        VStack {
//            Text("Create note page for \(accountName) + \(accountId)")
//                .font(.custom("Nunito-Regular", size: 24))
//                .fontWeight(.bold)
//                .padding()
//
//            // Add the rest of your content for the Create Note screen here...
//        }
//    }
//}
