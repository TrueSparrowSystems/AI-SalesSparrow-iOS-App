//
//  BottomBar.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct BottomBar: View {
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
                self.createNoteScreenActivated = true
            }) {
                Image("CreateNoteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44.0, height: 44.0)
                                    
            }
            .padding(.bottom, 30) // Center the button in the middle of the 27px area
            .accessibilityIdentifier("btn_create_note")
        }
        .frame(height: 27) // Set the total height of the bottom nav bar to 50px
        .background(
            NavigationLink(
                destination: CreateNoteScreen(isAccountSelectable: true),
                isActive: self.$createNoteScreenActivated
            ) {
                EmptyView()
            }
                .hidden()
        )
        
        
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar()
            .previewLayout(.sizeThatFits)
    }
}
