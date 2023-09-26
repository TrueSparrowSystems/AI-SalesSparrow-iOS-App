//
//  BottomBar.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 03/08/23.
//

import SwiftUI

struct BottomBar: View {
    @State var createNoteScreenActivated = false
    @State var selectedAccountId: String?
    @State var selectedAccountName: String?
    
    var body: some View {
        ZStack {
            Color("Background")
                .frame(height: 44)
                .overlay(
                    Rectangle().frame(width: nil, height: 0.5, alignment: .top).foregroundColor(.black.opacity(0.2)), alignment: .top
                )
            
            // Button for headerIcon at the middle of the navbar
            Button(action: {
                self.createNoteScreenActivated = true
            }, label: {
                Image("AddIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44.0, height: 44.0)
                
            }
            )
            .offset(y: -22)
            .accessibilityIdentifier("btn_create_note")
        }
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
