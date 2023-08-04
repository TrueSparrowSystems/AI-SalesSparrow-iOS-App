//
//  AccountList.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

//import SwiftUI
//
//struct AccountList: View {
//    // TODO: Replace Below View Model with actual VM and other logic
//    @EnvironmentObject var accountListViewModel : AccountSearchViewModel
//
//    var body: some View {
//        List (accountListViewModel.listData) { account in
//            NavigationLink(destination: CreateNoteView(account: account)) {
//                AccountRowView(account: account)
//                    .onTapGesture {
//                        print(account.name)
//                    }
//            }
//        }
//        .listStyle(PlainListStyle())
//        .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
//    }
//}
//
//struct AccountList_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountList()
//    }
//}
