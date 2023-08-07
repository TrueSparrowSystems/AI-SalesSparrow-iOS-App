//
//  BottomBar.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct BottomBar: View {
    @State private var showAccountSearchView2: Bool = false
    @State var createNoteScreenActivated = false
    @State var selectedAccountId: String? = nil
    @State var selectedAccountName: String? = nil
    
    var body: some View {
        ZStack() {
            Color("Background")
                .frame(height: 27) // Set the height of the bottom 27px to be similar to Rectangle()
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color("Background"), lineWidth: 0.5)
                        .opacity(0.2)
                )
            
            // Button for headerIcon at the middle of the nave bar
            Button(action: {
                showAccountSearchView2 = true
            }) {
                Image("CreateNoteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44.0, height: 44.0)
            }
            .padding(.bottom, 30) // Center the button in the middle of the 27px area
            .sheet(isPresented: $showAccountSearchView2, onDismiss: {
                // Clear data
                print("Sheet dismissed - Clear Search data from View model")
            }) {
                AccountSearchView(isPresented: $showAccountSearchView2, isCreateNoteFlow: true, onNoteCreateSelected: { accountId, accountName in
                    print("Create Note for \(accountName) \(accountId)")
                    
                    selectedAccountId = accountId
                    selectedAccountName = accountName
                    self.createNoteScreenActivated = true
                })
            }
        }
        .frame(height: 27) // Set the total height of the bottom nav bar to 50px
        .background(
            Group {
                if self.createNoteScreenActivated && selectedAccountId != nil{
                    NavigationLink(
                        destination: CreateNoteScreen(accountId: selectedAccountId!, accountName: selectedAccountName!, isAccountSelectable: true),
                        isActive: self.$createNoteScreenActivated
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        )
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar()
            .previewLayout(.sizeThatFits)
    }
}
