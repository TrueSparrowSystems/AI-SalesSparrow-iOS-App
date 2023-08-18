//
//  AccountList.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct AccountList: View {
    // TODO: Replace Below View Model with actual VM and other logic
    @EnvironmentObject var accountSearchListViewModel : AccountSearchViewModel
    @State var accountDetailsScreenActivated = false
    
    var body: some View {
        let accountIds = accountSearchListViewModel.accountListData.account_ids
        
        ScrollView {
            ForEach(accountIds, id: \.self) { accountId in
                if let account = accountSearchListViewModel.accountListData.account_map_by_id[accountId] {
                    NavigationLink(destination: AccountDetailsScreen(accountId: accountId, accountName: account.name)) {
                        AccountRowView(account: account)
                            .onTapGesture {
                                print(account.name)
                            }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
    }
}

struct AccountList_Previews: PreviewProvider {
    static var previews: some View {
        AccountList()
    }
}
