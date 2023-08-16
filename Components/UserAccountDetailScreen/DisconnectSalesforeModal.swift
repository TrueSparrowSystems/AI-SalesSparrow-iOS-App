//
//  DisconnectSalesforeModal.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 16/08/23.
//

import SwiftUI

struct DisconnectSalesforceModal : View{
    @Binding var disconnectSalesforceModel: Bool
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing:0) {
                VStack (spacing: 16) {
                    Text("**Disconnect Salesforce**")
                        .font(.system(size: 17))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                    
                    Text("This will **delete your account** and all details associated with it. This is an irreversible process, are you sure you want to do this?")
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                
                Divider()
                
                HStack(spacing: 0) {
                    Button(action: {
                        // Handle cancel action
                        disconnectSalesforceModel = false
                    }) {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color("CancelButtonForeground"))
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Divider()
                            .frame(maxWidth: 1, maxHeight: .infinity)
                        ,alignment: .trailing
                    )
                    
                    Button(action: {
                        // Handle disconnect action
                        userStateViewModel.disconnectUser()
                        // Perform the disconnect process
                    }) {
                        Text("Disconnect")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color("DisconnectButtonForeground"))
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color("DisconnectModalBackground"))
            .cornerRadius(14)
            .frame(width: 270, height: 172.5)
            
        }

    }
}
