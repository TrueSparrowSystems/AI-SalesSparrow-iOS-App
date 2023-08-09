//
//  TopBar.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct TopBar: View {
    @State private var showAccountSearchView: Bool = false
    @State var accountDetailsScreenActivated = false
    @State var createNoteScreenActivated = false
    @State var selectedAccountId: String? = nil
    @State var selectedAccountName: String? = nil
    
    var body: some View {
        HStack {
            Image("Buildings")
                .frame(width: 28.0, height: 28.0)
            
            Text("Accounts")
                .font(.custom("Nunito-Regular",size: 24))
                .fontWeight(.bold)
                .frame(width: 103.0, height: 33.0)
            
            Spacer()
            
            Image("MagnifyingGlass")
                .onTapGesture {
                    showAccountSearchView = true
                }
                .accessibilityIdentifier("btn_search_account")
                .sheet(isPresented: $showAccountSearchView, onDismiss: {
                    // Clear data
                    print("Clear Search data from View model")
                }) {
                    AccountSearchView(isPresented: $showAccountSearchView, onAccountSelected: { accountId, accountName in
                        print("\(accountId) Search deatail Account")
                        
                        // Use ID to push view to navigation link
                        selectedAccountId = accountId
                        selectedAccountName = accountName
                        self.accountDetailsScreenActivated = true
                    }, onNoteCreateSelected: { accountId, accountName in
                        print("Create Note for \(accountName) \(accountId)")
                        
                        selectedAccountId = accountId
                        selectedAccountName = accountName
                        self.createNoteScreenActivated = true
                    })
                }
        }
        .foregroundColor(Color("TextPrimary"))
        .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
        .background(Color.clear) // Make the top 23px transparent]
        .background(
            Group {
                if self.accountDetailsScreenActivated && selectedAccountId != nil {
                    NavigationLink(
                        destination: AccountDetailsScreen(accountId: selectedAccountId!, accountName: selectedAccountName!),
                        isActive: self.$accountDetailsScreenActivated
                    ) {
                        EmptyView()
                    }
                    .hidden()
                } else if self.createNoteScreenActivated && selectedAccountId != nil{
                    NavigationLink(
                        destination: CreateNoteScreen(accountId: selectedAccountId!, accountName: selectedAccountName!, isAccountSelectable: false),
                        isActive: self.$createNoteScreenActivated
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        )
    }
}

//struct TopBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TopBar()
//    }
//}
