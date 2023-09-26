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
        VStack {
            HStack {
                Image(Asset.addressBook.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25.0, height: 25.0)
                    .accessibilityIdentifier("img_account_detail_contact_icon")

                Text("Contact Details")
                    .accessibilityIdentifier("txt_account_detail_contact_details_title")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.nunitoSemiBold(size: 16))

                Spacer()
            }
            VStack(spacing: 0) {
                // Iterate through contacts
                let associationId = accountDetailViewModelObject.accountDetail.account_contact_associations_id ?? ""

                let contactIds = accountDetailViewModelObject.accountDetail.account_contact_associations_map_by_id?[associationId]?.contact_ids ?? []

                ForEach(Array(contactIds.enumerated()), id: \.offset) { index, contactId in
                    let contact = accountDetailViewModelObject.accountDetail.contact_map_by_id?[contactId]
                    if contact != nil {
                        VStack(spacing: 5) {
                            HStack(spacing: 0) {
                                Text("CONTACT \(index + 1)")
                                    .font(.nunitoBold(size: 14))
                                    .foregroundColor(Color("TextPrimary"))
                                    .accessibilityIdentifier("txt_account_detail_contact_number_index_\(index)")
                                    .opacity(0.7)
                                
                                Spacer()
                            }
                            HStack(spacing: 0) {
                                Text(contact?.name ?? "")
                                    .font(.nunitoSemiBold(size: 18))
                                    .foregroundColor(Color("TextPrimary"))
                                    .accessibilityIdentifier("txt_account_detail_contact_name_index_\(index)")
                                
                                Spacer()
                                
                            }
                            
                            let additionalFields = contact?.additional_fields
                            
                            if additionalFields != nil {
                                ForEach(Array(additionalFields ?? [:]), id: \.key) { key, value in
                                    RenderFields(fieldName: key, fieldValue: value ?? "")
                                }
                            }
                            
                            if index != contactIds.indices.last {
                                Divider()
                                    .frame(height: 1)
                                    .foregroundColor(Color("BorderColor"))
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
                    .stroke(Color("BorderColor"), lineWidth: 1)
            )
        }
        .padding(.trailing)
    }
}
