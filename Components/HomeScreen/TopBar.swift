//
//  TopBar.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct TopBar: View {
    @State private var showAccountSearchView: Bool = false
    @EnvironmentObject var AcccountSearchViewModelObject: AccountSearchViewModel
    @State var accountDetailScreenActivated = false
    @State var createNoteScreenActivated = false
    @State var selectedAccountId: Int? = nil
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
                .sheet(isPresented: $showAccountSearchView, onDismiss: {
                    // Clear data
                    print("Clear Search data from View model")
                }) {
                    AccountSearchView(isPresented: $showAccountSearchView, onAccountSelected: { accountId in
                        print("\(accountId) Search deatail Account")
                        
                        // Use ID to push view to navigation link
                        selectedAccountId = accountId
                        self.accountDetailScreenActivated = true
                    }, onNoteCreateSelected: { account in
                        print("Create Note for \(account.name) \(account.id)")
                        
                        selectedAccountId = account.id
                        selectedAccountName = account.name
                        self.createNoteScreenActivated = true
                    })
                }
        }
        .foregroundColor(Color("TextPrimary"))
        .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
        .background(Color.clear) // Make the top 23px transparent]
        .background(
            Group {
                if self.accountDetailScreenActivated && selectedAccountId != nil {
                    NavigationLink(
                        destination: AccountDetailScreen(pushActive: $accountDetailScreenActivated, accountId: selectedAccountId!),
                        isActive: self.$accountDetailScreenActivated
                    ) {
                        Text("WTF ROOR")
                    }
                    .hidden()
                } else if self.createNoteScreenActivated && selectedAccountId != nil{
                    NavigationLink(
                        destination: CreateNoteView(pushActive: $createNoteScreenActivated, accountId: selectedAccountId!, accountName: selectedAccountName!),
                        isActive: self.$createNoteScreenActivated
                    ) {
                        Text("WTF ROOR")
                    }
                    .hidden()
                }
            }
        )
    }
}

struct AccountDetailScreen: View {
    @Binding var pushActive: Bool
    var accountId: Account.ID
    
    var body: some View {
        VStack{
            Text("Pushed the view in into the stack with \(accountId)")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
                .onTapGesture {
                    pushActive = false
                }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            // Pop the view from the navigation stack by setting pushActive to false
            // This will dismiss the AccountDetailScreen and go back to the previous view
            pushActive = false
        }) {
            Image(systemName: "chevron.left")
                .font(.title2)
        }
    }
}

//struct TopBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TopBar()
//    }
//}
