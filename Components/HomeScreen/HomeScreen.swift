//
//  HomeScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct HomeScreen: View {
    @State private var showAccountSearchView: Bool = false
    @State private var showCreateNoteAccountSearchView: Bool = false
    @ObservedObject private var viewModel = SearchAccountViewModel()
    
    init() {
            // Initialize the view model and fetch data
            viewModel.fetchData()
        }
    
    var body: some View {
        VStack {
            // Top Bar
            HStack {
                Image("Buildings")
                    .frame(width: 28.0, height: 28.0)
                
                Text("Accounts")
                    .font(.custom("Nunito-Regular",size: 24))
                    .fontWeight(.bold)
                    .frame(width: 103.0, height: 33.0)
                Spacer()
                Image("MagnifyingGlass")
                    .onTapGesture {
                        showAccountSearchView = true
                    }
                    .sheet(isPresented: $showAccountSearchView) {
                        AccountSearchView(forAccountSearch: true)
                    }
                
            }
            .foregroundColor(Color("TextPrimary"))
            .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
            .background(Color.clear) // Make the top 23px transparent
            
            // List of Accounts
            List (viewModel.listData) { account in
                AccountRowView(account: account)
                    .background(Color("Background"))
            }
            .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
            
            // Bottom Bar with + Button
            ZStack() {
                Color("Background")
                    .frame(height: 27) // Set the height of the bottom 27px to be similar to Rectangle()
                
                // Button for headerIcon at the middle of the nave bar
                Button(action: {
                    showCreateNoteAccountSearchView = true
                }) {
                    Image("HeaderIcons")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44.0, height: 44.0)
                }
                .padding(.bottom, 30) // Center the button in the middle of the 27px area
                .sheet(isPresented: $showCreateNoteAccountSearchView) {
                    AccountSearchView()
                }
                
            }
            .frame(height: 27) // Set the total height of the bottom nav bar to 50px
        }
        .background(Color("Background"))
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
