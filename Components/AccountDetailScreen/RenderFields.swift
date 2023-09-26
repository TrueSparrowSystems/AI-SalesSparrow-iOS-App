//
//  RenderFields.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 15/09/23.
//

import SwiftUI

struct RenderFields: View {
    var fieldName: String
    var fieldValue: String
    @EnvironmentObject var accountDetailViewModelObject: AccountDetailScreenViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        let fieldInfo = accountDetailViewModelObject.customFields.fields[fieldName]
        let fieldTitle = fieldInfo?.title
        
        switch fieldInfo?.type {
        case .TITLE:
            HStack(spacing: 0) {
                Text(fieldValue)
                    .font(.nunitoRegular(size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_field_type_\(fieldName)")
                
                Spacer()
            }
        case .EMAIL:
            HStack(spacing: 0) {
                Text(fieldValue)
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_field_type_\(fieldName)")
                
                Spacer()
            }
        case .STRING:
                HStack(spacing: 0) {
                    Text("\(fieldTitle!): ")
                        .font(.nunitoMedium(size: 14))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_account_detail_field_type_\(fieldName)")
                    
                    Text("\(fieldValue)")
                        .font(.nunitoMedium(size: 14))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_account_detail_field_value_\(fieldValue)")
                    
                    Spacer()
                }
            
        case .LINK:
            HStack(spacing: 0) {
                Image(Asset.link.name)
                    .frame(width: 12, height: 12)
                    .padding(.leading, 2)
                    .padding(.trailing, 4)
                
                Text("\(fieldTitle!): ")
                    .font(.nunitoMedium(size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_field_type_\(fieldName)")
                
                Text("\(fieldValue)")
                    .font(.nunitoMedium(size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .underline(true, color: Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_field_value_\(fieldValue)")
                    .onTapGesture {
                        openURL(URL(string: fieldValue)!)
                        }
                
                Spacer()
            }
        default:
            EmptyView()
        }
    }
}
