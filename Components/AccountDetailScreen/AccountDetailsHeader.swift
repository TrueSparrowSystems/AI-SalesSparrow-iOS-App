//
//  AccountDetailsHeader.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import SwiftUI

struct AccountDetailsHeader: View {
    @EnvironmentObject var accountDetailViewModelObject: AccountDetailScreenViewModel
    var accountId: String
    var accountName: String
    @State var expandAccountDetails: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(Asset.buildings.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25.0, height: 25.0)
                    .accessibilityIdentifier("img_account_detail_account_icon")
                
                Text("Account Details")
                    .accessibilityIdentifier("txt_account_detail_account_details_title")
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .font(.nunitoSemiBold(size: 16))
                
                Spacer()
            }
            VStack(spacing: 5) {
                VStack {
                    HStack {
                        Text("ACCOUNT")
                            .accessibilityIdentifier("txt_account_detail_account_text")
                            .font(.nunitoBold(size: 12))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .opacity(0.7)
                        
                        Spacer()
                    }
                    HStack {
                        Text(accountDetailViewModelObject.accountDetail.name)
                            .accessibilityIdentifier("txt_account_detail_account_name")
                            .font(.nunitoSemiBold(size: 18))
                            .foregroundColor(Color(Asset.textPrimary.name))
                        
                        Spacer()
                    }
                }
                // loop of additional fields
                if !expandAccountDetails {
                    let additionalFields = accountDetailViewModelObject.accountDetail.additional_fields
                    if let additionalFields = additionalFields {
                        ForEach(Array(additionalFields.keys.prefix(2)), id: \.self) { key in
                            if let value = additionalFields[key], accountDetailViewModelObject.customFields.fields[key] != nil {
                                RenderFields(fieldName: key, fieldValue: value ?? "")
                            }
                        }
                    }
                    
                    if additionalFields?.count ?? 0 > 2 {
                        Divider()
                        
                        Button(action: {
                            expandAccountDetails = true
                        }, label: {
                            HStack(alignment: .center) {
                                Text("More Details")
                                    .foregroundColor(Color(Asset.redHighlight.name))
                                    .font(.nunitoMedium(size: 14))
                            }
                        }
                        )
                        .accessibilityIdentifier("btn_account_detail_more_details")
                    }
                } else {
                    let additionalFields = accountDetailViewModelObject.accountDetail.additional_fields
                    if let additionalFields = additionalFields {
                        ForEach(Array(Array(additionalFields.keys).enumerated()), id: \.offset) { index, key in
                            if let value = additionalFields[key], accountDetailViewModelObject.customFields.fields[key] != nil {
                                VStack(spacing: 0) {
                                    RenderFields(fieldName: key, fieldValue: value ?? "")
                                    
                                    if index+1 != additionalFields.keys.count {
                                        Divider()
                                            .frame(height: 1)
                                            .foregroundColor(Color(Asset.borderColor.name))
                                            .padding(.vertical, 8)
                                    }
                                }
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
