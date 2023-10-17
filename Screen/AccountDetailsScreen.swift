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
    @EnvironmentObject var accountDetailViewModelObject : AccountDetailScreenViewModel
    @State var propagateClick = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
                VStack(spacing: 20) {
                    
                    AccountDetailsHeader(accountId: accountId, accountName: accountName)
                    
                    // Contact list component
                    //                AccountContactDetail(accountId: accountId, accountName: accountName)
                    
                    NotesList(accountId: accountId, accountName: accountName, propagateClick: $propagateClick)
                        .id("NotesList")
                    
                    TasksList(accountId: accountId, accountName: accountName, propagateClick: $propagateClick)
                        .id("TasksList")
                    
                    EventsList(accountId: accountId, accountName: accountName, propagateClick: $propagateClick)
                        .id("EventsList")
                }
            }
            .onAppear {
                //            accountDetailViewModelObject.fetchAccountDetail(accountId: accountId)
                if !accountDetailViewModelObject.scrollToSection.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        proxy.scrollTo(accountDetailViewModelObject.scrollToSection)
                        accountDetailViewModelObject.scrollToSection = ""
                    }
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded(){
                    propagateClick += 1
                }
            )
            .simultaneousGesture(
                DragGesture().onChanged{_ in
                    propagateClick += 1
                }
            )
            .padding(.vertical)
            .padding(.leading)
            .background(Color("Background"))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            // This will dismiss the AccountDetailsScreen and go back to the previous view
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("ArrowLeft")
                    .frame(width: 24.14,height: 24.14)
                Text("Details")
                    .font(.custom("Nunito-SemiBold",size: 16))
                    .foregroundColor(Color("SaveButtonBackground"))
            }
            .foregroundColor(Color("SaveButtonBackground"))
        }
        .accessibilityIdentifier("btn_account_detail_back")
    }
}

