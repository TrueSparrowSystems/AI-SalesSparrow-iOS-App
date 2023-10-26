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
    @State var selectedAccountId: String?
    @State var selectedAccountName: String?
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    
    var body: some View {
        NavigationStack {
            HStack {
                Image("Buildings")
                    .frame(width: 28.0, height: 28.0)
                    .accessibilityIdentifier("img_home_screen_account_icon")
                
                Text("Accounts")
                    .font(.custom("Nunito-Regular", size: 24))
                    .fontWeight(.bold)
                    .frame(width: 103.0, height: 33.0)
                    .accessibilityIdentifier("txt_account_details_title")
                
                Spacer()
                
                Image("MagnifyingGlass")
                    .onTapGesture {
                        showAccountSearchView = true
                    }
                    .accessibilityIdentifier("btn_search_account")
                    .sheet(isPresented: $showAccountSearchView) {
                        AccountSearchView(isPresented: $showAccountSearchView, onAccountSelected: { accountId, accountName in
                            
                            // Use ID to push view to navigation link
                            selectedAccountId = accountId
                            selectedAccountName = accountName
                            self.accountDetailsScreenActivated = true
                        }, onNoteCreateSelected: { accountId, accountName in
                            
                            selectedAccountId = accountId
                            selectedAccountName = accountName
                            self.createNoteScreenActivated = true
                        })
                    }
                NavigationLink(destination: UserAccountDetailScreen()
                    .navigationBarBackButtonHidden(true)) {
                        Text(BasicHelper.getInitials(from: userStateViewModel.currentUser.name))
                            .frame(width: 30, height: 30)
                            .font(.custom("Nunito-Bold", size: 9))
                            .foregroundColor(.black)
                            .accessibilityIdentifier("txt_user_account_icon")
                    }
                    .background(Color(hex: "#C5B8FA"))
                    .clipShape(Circle())
            }
            .foregroundColor(Color(Asset.textPrimary.name))
            .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
            .background(Color.clear) // Make the top 23px transparent]
            .navigationDestination(isPresented: self.$accountDetailsScreenActivated, destination: {
                AccountDetailsScreen(accountId: selectedAccountId ?? "0", accountName: selectedAccountName ?? "test account")
            })
            .navigationDestination(isPresented: self.$createNoteScreenActivated, destination: {
                CreateNoteScreen(accountId: selectedAccountId ?? "0", accountName: selectedAccountName ?? "test account", isAccountSelectable: false)
            })
        }
        
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar()
    }
}
