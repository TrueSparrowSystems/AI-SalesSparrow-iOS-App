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
    @EnvironmentObject var accountDetailViewModelObject : AccountDetailScreenViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        let fieldInfo = accountDetailViewModelObject.customFields.fields[fieldName]
        let fieldTitle = fieldInfo?.title
        
        switch fieldInfo?.type {
        case .TITLE:
            HStack(spacing: 0){
                Text(fieldValue)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                
                Spacer()
            }
        case .EMAIL:
            HStack(spacing: 0){
                Text(fieldValue)
                    .font(.custom("Nunito-Regular",size: 12))
                    .foregroundColor(Color("TextPrimary"))
                
                Spacer()
            }
        case .STRING:
                HStack(spacing: 0){
                    Text("\(fieldTitle!): ")
                        .font(.custom("Nunito-Medium",size: 14))
                        .foregroundColor(Color("TextPrimary"))
                    
                    Text("\(fieldValue)")
                        .font(.custom("Nunito-Medium",size: 14))
                        .foregroundColor(Color("TextPrimary"))
                    
                    Spacer()
                }
            
        case .LINK:
            HStack(spacing: 0) {
                Image("Link")
                    .frame(width: 12,height: 12)
                    .padding(.horizontal, 2)
                
                Text("\(fieldTitle!): ")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                
                Text("\(fieldValue)")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .underline(true, color: Color("TextPrimary"))
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
