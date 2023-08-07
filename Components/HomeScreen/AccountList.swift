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
    @State var accountDetailScreenActivated = false
    
    var body: some View {
        List (accountSearchListViewModel.listData) { account in
            NavigationLink(destination: AccountDetailScreen(pushActive: $accountDetailScreenActivated,accountId: account.id)) {
                AccountRowView(account: account)
                    .onTapGesture {
                        print(account.name)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
        .onAppear {
            accountSearchListViewModel.fetchData()
        }
    }
}

struct AccountList_Previews: PreviewProvider {
    static var previews: some View {
        AccountList()
    }
}
