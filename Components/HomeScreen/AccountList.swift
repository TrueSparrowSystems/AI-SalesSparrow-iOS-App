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
    @State var fetchFirstPage = true
    
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
                List {
                    ForEach(Array(accountIds.enumerated()), id: \.offset) { index, accountId in
                        if let account = acccountListViewModelObject.accountListData.account_map_by_id[accountId] {
                            ZStack {
                                AccountRowView(account: account, index: index)
                                    .onAppear{
                                        if(accountIds.count == index + 1){
                                            acccountListViewModelObject.fetchData()
                                        }
                                    }
                                NavigationLink(destination: AccountDetailsScreen(accountId: accountId, accountName: account.name)) {
                                    EmptyView()
                                }
                                .buttonStyle(.plain)
                                .opacity(0)
                                .accessibilityIdentifier("account_card_\(index)")
                            }
                            .listRowBackground(Color("Background"))
                            .listRowSeparator(.hidden)
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                    
                    if(acccountListViewModelObject.isFetchAccountInProgress && accountIds.count > 0){
                        HStack(spacing: 0){
                            ProgressView()
                                .tint(Color("LoginButtonSecondary"))
                                .accessibilityAddTraits(.isImage)
                                .accessibilityIdentifier("next_page_loader")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .contentShape(Rectangle())
                        .padding(0)
                        .listRowBackground(Color("Background"))
                        .listRowSeparator(.hidden)
                    }
                }
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .accessibilityIdentifier("account_list_scroll_view")
            }
        }
        .onAppear{
            if(self.fetchFirstPage){
                self.fetchFirstPage = false
                acccountListViewModelObject.fetchData()
            }
        }
        
    }
}

struct AccountRowView: View {
    var account: Account
    var index: Int
    @Environment(\.openURL) var openURL
    @EnvironmentObject var acccountListViewModelObject : AccountListViewModel
    
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
                .lineLimit(1)
                .accessibilityIdentifier("txt_account_list_account_name_index_\(index)")
                .accessibilityElement()
            
            
            //TODO: On Field customization remove hardcoded values and show all additional_fields
            if(!((account.additional_fields?["website"] ?? "") ?? "").isEmpty){
                HStack{
                    Image("Link")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text(account.additional_fields?["website"]! ?? "")
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(Color("TermsPrimary"))
                        .accessibilityIdentifier("txt_account_list_account_website_index_\(index)")
                        .accessibilityElement()
                    
                }
                .onTapGesture {
                    openURL(URL(string: account.additional_fields?["website"]! ?? "")!)
                }
                .padding(.top, 2)
            }
            
            let accountContactAssociation = acccountListViewModelObject.accountListData.account_contact_associations_map_by_id[account.account_contact_associations_id ?? ""]
            
            if((accountContactAssociation) != nil){
                let contactIds = accountContactAssociation?.contact_ids
                
                let contact = acccountListViewModelObject.accountListData.contact_map_by_id[contactIds?.first ?? ""]
                if(contact != nil){
                    VStack(alignment: .leading, spacing: 0){
                        Text("CONTACT")
                            .font(.custom("Nunito-Bold",size: 12))
                            .foregroundColor(Color("TermsPrimary").opacity(0.7))
                            .tracking(0.5)
                            .padding(.bottom, 6)
                        
                        Text(contact?.name ?? "")
                            .font(.custom("Nunito-SemiBold",size: 18))
                            .tracking(0.5)
                            .foregroundColor(Color("TermsPrimary"))
                            .accessibilityIdentifier("txt_account_list_account_contact_name_index_\(index)")
                            .accessibilityElement()
                        
                        if(!((contact?.additional_fields?["email"] ?? "") ?? "").isEmpty){
                            Text((contact?.additional_fields?["email"])! ?? "")
                                .font(.custom("Nunito-Regular",size: 14))
                                .foregroundColor(Color("TermsPrimary"))
                                .accessibilityIdentifier("txt_account_list_account_email_index_\(index)")
                                .accessibilityElement()
                        }
                        
                    }
                    .padding(.top, 16)
                }
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
