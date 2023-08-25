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
                List {
                    ForEach(Array(accountIds.enumerated()), id: \.offset) { index, accountId in
                        if let account = acccountListViewModelObject.accountListData.account_map_by_id[accountId] {
                            ZStack {
                                AccountRowView(account: account)
                                    .onAppear{
                                        print(account.name)
                                        if(accountIds.last == accountId){
                                            acccountListViewModelObject.fetchData()
                                        }
                                    }
                                
                                NavigationLink(destination: AccountDetailsScreen(accountId: accountId, accountName: account.name)) {
                                    EmptyView()
                                }
                                .buttonStyle(.plain)
                                .opacity(0)
                            }
                            .listRowBackground(Color("Background"))
                            .listRowSeparator(.hidden)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityIdentifier("account_card_\(index)")
                        }
                    }
                    HStack{
                        if(acccountListViewModelObject.isFetchAccountInProgress && accountIds.count > 0){
                            ProgressView()
                                .tint(Color("LoginButtonSecondary"))
                                .listRowBackground(Color("Background"))
                                .listRowSeparator(.hidden)
                                .accessibilityAddTraits(.isImage)
                                .accessibilityIdentifier("next_page_loader")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .accessibilityIdentifier("account_list_scroll_view")
            }
        }
        .onAppear{
            acccountListViewModelObject.fetchData()
        }
        
    }
}

struct AccountRowView: View {
    var account: Account
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
            
            
            //TODO: On Field customization remove hardcoded values and show all additional_fields
            if((account.additional_fields["website"]) != nil){
                HStack{
                    Image("Link")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(account.additional_fields["website"]!!)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(Color("TermsPrimary"))
                    
                }
                .onTapGesture {
                    openURL(URL(string: account.additional_fields["website"]!!)!)
                }
                .padding(.top, 2)
            }
            
            let accountContactAssociation = acccountListViewModelObject.accountListData.account_contact_associations_map_by_id[account.account_contact_associations_id]
            
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
                        
                        if((contact?.additional_fields["email"]) != nil){
                            Text((contact?.additional_fields["email"])!!)
                                .font(.custom("Nunito-Regular",size: 14))
                                .foregroundColor(Color("TermsPrimary"))
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
