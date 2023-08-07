//
//  HomeScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct HomeScreen: View {
    @State private var showCreateNoteAccountSearchView: Bool = false
    @StateObject var acccountSearchViewModelObject = AccountSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Top Bar
                TopBar()
                
                // List of Accounts
//                AccountList()
                Spacer()
                
                // Bottom Bar with + Button
                BottomBar()
            }
            .background(Color("Background"))
            
        }
        .environmentObject(acccountSearchViewModelObject)
    }
}

struct AccountRowView: View {
    var account: Account
    
    var body: some View {
        // Account Row
        HStack {
            Image("Buildings")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44.0, height: 44.0)
            
            Text(account.name)
                .font(.custom("Nunito-Regular",size: 16))
                .fontWeight(.bold)
            
            
            Spacer()
            
            Text("\(account.id)")
                .font(.custom("Nunito-Regular",size: 12))
            
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
