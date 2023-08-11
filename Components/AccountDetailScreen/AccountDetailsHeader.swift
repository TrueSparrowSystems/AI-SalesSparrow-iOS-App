//
//  AccountDetailsHeader.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import SwiftUI

struct AccountDetailsHeader: View {
    var accountId: String
    var accountName: String
    
    var body: some View {
        VStack{
            HStack{
                Image("Buildings")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25.0, height: 25.0)
                
                Text("Account Details")
                    .font(.custom("Nunito-SemiBold",size: 16))
                    .foregroundColor(Color("SaveButtonBackground"))
                
                Spacer()
            }
            VStack(spacing: 5) {
                HStack {
                    Text("ACCOUNT")
                        .font(.custom("Nunito-Bold",size: 12))
                        .foregroundColor(Color("TermsPrimary"))
                        .opacity(0.7)
                    
                    Spacer()
                }
                HStack {
                    Text(accountName)
                        .font(.custom("Nunito-Bold",size: 18))
                        .foregroundColor(Color("TermsPrimary"))
                    
                    Spacer()
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
