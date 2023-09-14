//
//  AccountDetailsHeader.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import SwiftUI

struct AccountDetailsHeader: View {
    @EnvironmentObject var accountListViewModelObject : AccountListViewModel
    var accountId: String
    var accountName: String
    @State var expandAccountDetails: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Image("Buildings")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25.0, height: 25.0)
                    .accessibilityIdentifier("img_account_detail_account_icon")
                
                Text("Account Details")
                    .accessibilityIdentifier("txt_account_detail_account_details_title")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-SemiBold",size: 16))
                
                Spacer()
            }
            VStack(spacing: 5) {
                HStack {
                    Text("ACCOUNT")
                        .accessibilityIdentifier("txt_account_detail_account_text")
                        .font(.custom("Nunito-Bold",size: 12))
                        .foregroundColor(Color("TextPrimary"))
                        .opacity(0.7)
                    
                    Spacer()
                }
                HStack {
                    Text(accountName)
                        .accessibilityIdentifier("txt_account_detail_account_name")
                        .font(.custom("Nunito-Bold",size: 18))
                        .foregroundColor(Color("TextPrimary"))
                    
                    
                    Spacer()
                }
                
                // loop of additional fields
                if(!expandAccountDetails){
                    let additionalFields = accountListViewModelObject.accountListData.account_map_by_id[accountId]?.additional_fields
                    if let additionalFields = additionalFields {
                        ForEach(Array(additionalFields.keys.prefix(3)), id: \.self) { key in
                            if let value = additionalFields[key] {
                                RenderFields(fieldName: key, fieldValue: value ?? "")
                            } else {
                                // Handle the case where the value is nil, if needed.
                            }
                        }
                    }
                    
                    if(additionalFields!.count > 2){
                        Divider()
                        
                        HStack{
                            Text("More Details")
                                .foregroundColor(Color("RedHighlight"))
                                .font(.custom("Nunito-Medium", size: 14))
                        }
                        .onTapGesture {
                            expandAccountDetails = true
                        }
                    }
                } else {
                    let additionalFields = accountListViewModelObject.accountListData.account_map_by_id[accountId]?.additional_fields
                    if let additionalFields = additionalFields {
                        ForEach(Array(additionalFields.keys), id: \.self) { key in
                            if let value = additionalFields[key] {
                                RenderFields(fieldName: key, fieldValue: value ?? "")
                            } else {
                                // Handle the case where the value is nil, if needed.
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

struct RenderFields: View {
    var fieldName: String
    var fieldValue: String
    @EnvironmentObject var accountListViewModelObject : AccountListViewModel
    
    var body: some View {
        let fieldInfo = accountListViewModelObject.customFields.fields[fieldName]
        let fieldTitle = fieldInfo?.title
        
        switch fieldInfo?.type {
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

