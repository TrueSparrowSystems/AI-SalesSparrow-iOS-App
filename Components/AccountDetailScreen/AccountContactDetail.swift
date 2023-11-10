//
//  AccountContactDetail.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 14/09/23.
//

import SwiftUI

struct AccountContactDetail: View {
    @EnvironmentObject var accountDetailViewModelObject: AccountDetailScreenViewModel
    var accountId: String
    var accountName: String
    @State var expandAccountDetails: Bool = false

    var body: some View {
        let associationId = accountDetailViewModelObject.accountDetail.account_contact_associations_id ?? ""
        let contactIds = accountDetailViewModelObject.accountContactAssociationsMapById[associationId]?.contact_ids ?? []
        
        if accountDetailViewModelObject.isFetchAccountDetailInProgress {
            EmptyView()
        } else {
            if contactIds.count != 0 {
                VStack {
                    HStack {
                        Image(Asset.addressBook.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25.0, height: 25.0)
                            .accessibilityIdentifier("img_account_detail_contact_icon")

                        Text("Contact Details")
                            .accessibilityIdentifier("txt_account_detail_contact_details_title")
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .font(.nunitoSemiBold(size: 16))

                        Spacer()
                    }
                    VStack(spacing: 0) {
                        // Iterate through contacts

                        ForEach(Array(contactIds.enumerated()), id: \.offset) { index, contactId in
                            let contact = accountDetailViewModelObject.contact_map_by_id[contactId]
                            if contact != nil {
                                VStack(spacing: 5) {
                                    HStack(spacing: 0) {
                                        Text("CONTACT \(index + 1)")
                                            .font(.nunitoBold(size: 14))
                                            .foregroundColor(Color(Asset.textPrimary.name))
                                            .accessibilityIdentifier("txt_account_detail_contact_number_index_\(index)")
                                            .opacity(0.7)
                                        
                                        Spacer()
                                    }
                                    HStack(spacing: 0) {
                                        Text(contact?.name ?? "")
                                            .font(.nunitoSemiBold(size: 18))
                                            .foregroundColor(Color(Asset.textPrimary.name))
                                            .accessibilityIdentifier("txt_account_detail_contact_name_index_\(index)")
                                        
                                        Spacer()
                                    }
                                    
                                    
                                    if !((contact?.additional_fields?["Title"] ?? "") ?? "").isEmpty {
                                        HStack{
                                            Text((contact?.additional_fields?["Title"])! ?? "")
                                                .font(.nunitoRegular(size: 14))
                                                .foregroundColor(Color(Asset.textPrimary.name))
                                                .accessibilityIdentifier("txt_account_list_contact_title_index_\(index)")
                                                .accessibilityElement()
                                            Spacer()
                                        }
                                    }
                             
                                    
                                    if !((contact?.additional_fields?["Email"] ?? "") ?? "").isEmpty {
                                        HStack{
                                            Text((contact?.additional_fields?["Email"])! ?? "")
                                                .font(.nunitoRegular(size: 12))
                                                .foregroundColor(Color(Asset.textPrimary.name))
                                                .accessibilityIdentifier("txt_account_list_account_email_index_\(index)")
                                                .accessibilityElement()
                                            Spacer()
                                        }
                                    }
                                    
                                    
                                    if index+1 != contactIds.indices.last {
                                        Divider()
                                            .frame(height: 1)
                                            .foregroundColor(Color(Asset.borderColor.name))
                                            .padding(.vertical, 12)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(5) /// make the background rounded
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(Asset.borderColor.name), lineWidth: 1)
                    )
                }
                .padding(.trailing)
            }
            
        }
    }
}
