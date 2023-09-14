//
//  AccountContactDetail.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 14/09/23.
//


import SwiftUI

struct AccountContactDetail: View {
    @EnvironmentObject var accountListViewModelObject : AccountListViewModel
    var accountId: String
    var accountName: String
    @State var expandAccountDetails: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Image("AddressBook")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25.0, height: 25.0)
                    .accessibilityIdentifier("img_account_detail_account_icon")
                
                Text("Contact Details")
                    .accessibilityIdentifier("txt_account_detail_account_details_title")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-SemiBold",size: 16))
                
                Spacer()
            }
            VStack(spacing: 5) {
                // Iterate through contacts
                if let contactIds = accountListViewModelObject.accountListData.account_contact_associations_map_by_id[(accountListViewModelObject.accountListData.account_map_by_id[accountId]?.account_contact_associations_id)!]?.contact_ids {
                    ForEach(contactIds, id: \.self) { contactId in
                        if let contact = accountListViewModelObject.accountListData.contact_map_by_id[contactId] {
                            HStack {
                                Text("CONTACT \(contactIds.firstIndex(of: contactId)! + 1)")
                                    .accessibilityIdentifier("txt_account_detail_account_text")
                                    .font(.custom("Nunito-Bold", size: 14))
                                    .foregroundColor(Color("TextPrimary"))
                                    .opacity(0.7)
                                
                                Spacer()
                            }
                            HStack {
                                Text(contact.name) // Assuming the contact has a 'name' property
                                    .accessibilityIdentifier("txt_account_detail_contact_\(contact.name)")
                                    .font(.custom("Nunito-Regular", size: 14))
                                    .foregroundColor(Color("TextPrimary"))
                                
                                Spacer()
                            }
                        }
                        
                        let additionalContactFields = accountListViewModelObject.accountListData.contact_map_by_id[contactId]?.additional_fields
                        if let additionalFields = additionalContactFields {
                            ForEach(Array(additionalFields.keys), id: \.self) { key in
                                if let value = additionalFields[key] {
                                    RenderContactFields(fieldName: key, fieldValue: value ?? "")
                                } else {
                                    // Handle the case where the value is nil, if needed.
                                }
                            }
                        }
                        
                        Divider()
                            .opacity(0.7)
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


struct RenderContactFields: View {
    var fieldName: String
    var fieldValue: String
    @EnvironmentObject var accountListViewModelObject : AccountListViewModel
    
    var body: some View {
        let fieldInfo = accountListViewModelObject.customFields.fields[fieldName]
        let fieldTitle = fieldInfo?.title
        
        switch fieldInfo?.type {
        case .TITLE:
            HStack{
                Text(fieldValue)
                    .accessibilityIdentifier("txt_account_detail_account_\(fieldValue)")
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
            }
        case .EMAIL:
            HStack{
                Text(fieldValue)
                    .accessibilityIdentifier("txt_account_detail_account_\(fieldValue)")
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
            }
        case .STRING:
            HStack{
                Text("\(fieldTitle!):")
                    .accessibilityIdentifier("txt_account_detail_account_\(fieldName)")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                
                Text("\(fieldValue)")
                    .accessibilityIdentifier("txt_account_detail_account_\(fieldValue)")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                
                Spacer()
            }
            
        case .LINK:
            HStack{
                Image("Link")
                
                Text("\(fieldTitle!):")
                    .accessibilityIdentifier("txt_account_detail_account_\(fieldName)")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                
                Text("\(fieldValue)")
                    .accessibilityIdentifier("txt_account_detail_account_\(fieldValue)")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .underline(true, color: Color("TextPrimary"))
                
                Spacer()
            }
        default:
            EmptyView()
        }
    }
}
