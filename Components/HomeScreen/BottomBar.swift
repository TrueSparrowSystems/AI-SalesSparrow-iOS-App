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
    @State var selectedAccountId: Int? = nil
    @State var selectedAccountName: String? = nil
    
    var body: some View {
        ZStack() {
            Color("Background")
                .frame(height: 27) // Set the height of the bottom 27px to be similar to Rectangle()
            
            // Button for headerIcon at the middle of the nave bar
            Button(action: {
                showAccountSearchView2 = true
            }) {
                Image("HeaderIcons")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44.0, height: 44.0)
            }
            .padding(.bottom, 30) // Center the button in the middle of the 27px area
            .sheet(isPresented: $showAccountSearchView2, onDismiss: {
                // Clear data
                print("Sheet dismissed - Clear Search data from View model")
            }) {
                AccountSearchView(isPresented: $showAccountSearchView2, isCreateNoteFlow: true, onNoteCreateSelected: { account in
                    print("Create Note for \(account.name) \(account.id)")
                    
                    selectedAccountId = account.id
                    selectedAccountName = account.name
                    self.createNoteScreenActivated = true
                })
            }
        }
        .frame(height: 27) // Set the total height of the bottom nav bar to 50px
        .background(
            Group {
                if self.createNoteScreenActivated && selectedAccountId != nil{
                    NavigationLink(
                        destination: CreateNoteView(pushActive: $createNoteScreenActivated, accountId: selectedAccountId!, accountName: selectedAccountName!),
                        isActive: self.$createNoteScreenActivated
                    ) {
                        Text("WTF ROOR")
                    }
                    .hidden()
                }
            }
        )
    }
}

//struct BottomBar_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomBar()
//    }
//}
