//
//  AccountList.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct AccountList: View {
    @EnvironmentObject var acccountListViewModelObject : AccountListViewModel
    @State var accountDetailsScreenActivated = false
    
    var body: some View {
        VStack{
            let accountIds = acccountListViewModelObject.accountListData.account_ids
            if(acccountListViewModelObject.isFetchAccountInProgress && accountIds.count == 0){
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color("LoginButtonSecondary"))
                    .controlSize(.large)
            }
            else{
                ScrollView {
                    ForEach(Array(accountIds.enumerated()), id: \.offset) { index, accountId in
                        if let account = acccountListViewModelObject.accountListData.account_map_by_id[accountId] {
                            NavigationLink(destination: AccountDetailsScreen(accountId: accountId, accountName: account.name)) {
                                AccountRowView(account: account)
                                    .onAppear{
                                        print(accountIds.last, accountId)
                                        if(accountIds.last == accountId){
                                            print(account.name)
                                            acccountListViewModelObject.fetchData()
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityIdentifier("account_card_\(index)")
                        }
                    }
                    HStack{
//                        if(acccountListViewModelObject.isFetchAccountInProgress && accountIds.count > 0){
                            ProgressView()
                                .tint(Color("LoginButtonSecondary"))
                                .accessibilityAddTraits(.isImage)
                                .accessibilityIdentifier("next_page_loader")
                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
                    }
                }
                .accessibilityIdentifier("account_list_scroll_view")
                .listStyle(PlainListStyle())
                
                
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .onAppear{
            acccountListViewModelObject.fetchData()
        }
        
    }
}

struct AccountRowView: View {
    var account: Account
    @Environment(\.openURL) var openURL
    
    var body: some View {
        // Account Row
        VStack(alignment: .leading, spacing: 0) {
            Text("ACCOUNT")
                .font(.custom("Nunito-Bold",size: 12))
                .foregroundColor(Color("TermsPrimary").opacity(0.7))
                .tracking(0.5)
                .padding(.bottom, 6)
            
            Text(account.name)
                .font(.custom("Nunito-SemiBold",size: 18))
                .tracking(0.5)
                .foregroundColor(Color("TermsPrimary"))
            
            
            if((account.website) != nil){
                HStack{
                    Image("Link")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(account.website!)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(Color("TermsPrimary"))
                    
                }
                .onTapGesture {
                    openURL(URL(string: account.website!)!)
                }
                .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(5) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("CardBorder"), lineWidth: 1)
        )
    }
}

struct AccountList_Previews: PreviewProvider {
    static var previews: some View {
        AccountList()
    }
}
