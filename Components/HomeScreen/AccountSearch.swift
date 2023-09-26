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
    var onNoteCreateSelected: ((String, String) -> Void)?  // Callback function to handle note creation selection
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .accessibilityIdentifier("img_search_magnifying_glass")
                
                TextField("", text: $searchText,
                          prompt: Text("Search Accounts").foregroundColor(Color("SearchPrimary").opacity(0.8)))
                .font(.nunitoRegular(size: 16))
                .foregroundColor(Color("LuckyPoint"))
                .accessibilityIdentifier("text_field_search_account")
                .focused($focused)
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
            
            if accountSearchViewModel.isSearchAccountInProgress {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color("LoginButtonSecondary"))
                    .controlSize(.large)
            } else if !accountSearchViewModel.accountListData.account_ids.isEmpty {
                // List of Accounts
                AccountListView(
                    listData: accountSearchViewModel.accountListData,
                    accountIds: accountSearchViewModel.accountListData.account_ids,
                    isCreateNoteFlow: isCreateNoteFlow,
                    onNoteCreateSelected: onNoteCreateSelected,
                    onAccountSelected: onAccountSelected,
                    isPresented: $isPresented,
                    removeSearchTextFocus: removeSearchTextFocus,
                    onScroll: onScroll
                )
            } else {
                Text("No Result Found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .accessibilityIdentifier("txt_search_no_result_found")
            }
        }
        .onAppear {
            accountSearchViewModel.fetchData("")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focused = true
            }
        }
        .background(Color("Background"))
    }
    
    func removeSearchTextFocus() {
        focused = false
    }
    func onScroll(_: DragGesture.Value) {
        focused = false
    }
}

struct AccountListView: View {
    var listData: SearchAccountStruct
    var accountIds: [String]
    var isCreateNoteFlow: Bool
    var onNoteCreateSelected: ((String, String) -> Void)?
    var onAccountSelected: ((String, String) -> Void)?
    @Binding var isPresented: Bool
    var removeSearchTextFocus: (() -> Void)
    var onScroll: ((DragGesture.Value) -> Void)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(accountIds, id: \.self) { accountId in
                    if let account = listData.account_map_by_id[accountId] {
                        HStack(alignment: .center) {
                            HStack {
                                Text(account.name)
                                    .font(.nunitoRegular(size: 16))
                                    .foregroundColor(Color("SearchPrimary"))
                                    .accessibilityIdentifier("txt_search_account_name_\(account.name)")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier("btn_search_account_name_\(account.name)")
                            .onTapGesture {
                                isPresented = false // Dismiss the sheet
                                removeSearchTextFocus()
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
                                        removeSearchTextFocus()
                                        onNoteCreateSelected?(accountId, account.name)
                                    }) {
                                        Text("Add Note")
                                            .font(.nunitoRegular(size: 16))
                                            .foregroundColor(Color("LoginButtonPrimary"))
                                            .accessibilityIdentifier("txt_search_add_note_\(account.name)")
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
        .simultaneousGesture(
            DragGesture().onChanged(
                    onScroll
            )
        )
    }
}
