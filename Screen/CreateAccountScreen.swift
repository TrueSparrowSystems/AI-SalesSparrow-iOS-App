//
//  CreateAccountScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 26/10/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                Text("Add New Account")
                    .font(.nunitoSemiBold(size: 24))
                    .accessibilityIdentifier("txt_add_new_account")
                    .foregroundColor(Color(Asset.loginScreenText.name))
                Spacer()
            }
            Spacer()
        }
        
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
}
