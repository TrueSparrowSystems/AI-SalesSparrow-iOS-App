//
//  AccountDetailsScreen.swift
//  SalesSparrow
//
//  Created by Alpesh Modi on 09/08/23.
//

import SwiftUI

struct AccountDetailsScreen: View {
    var accountId: String
    var accountName: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accountDetailViewModelObject: AccountDetailScreenViewModel
    @State var propagateClick = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                AccountDetailsHeader(accountId: accountId, accountName: accountName)
                
                // Contact list component
                AccountContactDetail(accountId: accountId, accountName: accountName)
                
                NotesList(accountId: accountId, accountName: accountName, propagateClick: $propagateClick)
                
                TasksList(accountId: accountId, accountName: accountName, propagateClick: $propagateClick)
                
                EventsList(accountId: accountId, accountName: accountName, propagateClick: $propagateClick)
                
            }
        }
        .onAppear {
            accountDetailViewModelObject.fetchAccountDetail(accountId: accountId)
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                propagateClick += 1
            }
        )
        .simultaneousGesture(
            DragGesture().onChanged {_ in
                propagateClick += 1
            }
        )
        .padding(.vertical)
        .padding(.leading)
        .background(Color(Asset.background.name))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: {
            // This will dismiss the AccountDetailsScreen and go back to the previous view
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(Asset.arrowLeft.name)
                    .frame(width: 24, height: 24)
                Text("Details")
                    .font(.nunitoSemiBold(size: 16))
                    .foregroundColor(Color(Asset.saveButtonBackground.name))
            }
            .foregroundColor(Color(Asset.saveButtonBackground.name))
        }
        )
        .accessibilityIdentifier("btn_account_detail_back")
    }
}
