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
    @State private var selectedAccount: Account? = nil
    @State private var isCreateNoteTrigger: Bool = false
    
    init() {
        // Initialize the view model and fetch data
        viewModel.fetchData()
    }
    
    var body: some View {
        NavigationView {
            ZStack{
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
                                AccountSearchView(forAccountSearch: true, isPresented: $showAccountSearchView, onAccountSelected: { account, isCreateNoteTrigger in
                                    print("\(account.id) + \(account.name) Pressed")
                                    selectedAccount = account
                                    self.isCreateNoteTrigger = isCreateNoteTrigger
                                })
                            }
                    }
                    .foregroundColor(Color("TextPrimary"))
                    .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
                    .background(Color.clear) // Make the top 23px transparent
                    
                    // List of Accounts
                    List (viewModel.listData) { account in
                        NavigationLink(destination: CreateNoteView(account: account)) {
                            AccountRowView(account: account)
                                .onTapGesture {
                                    print(account.name)
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
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
                            AccountSearchView(isPresented: $showCreateNoteAccountSearchView, onAccountSelected: { account, isCreateNoteTrigger in
                                print("\(account.id) + \(account.name) Pressed")
                                selectedAccount = account
                                self.isCreateNoteTrigger = true
                            })
                        }
                        
                    }
                    .frame(height: 27) // Set the total height of the bottom nav bar to 50px
                }
                .background(Color("Background"))
                
                if (selectedAccount != nil && !isCreateNoteTrigger) {
                    // Account details page
                    VStack {
                        Button("Dismiss") {
                            selectedAccount = nil
                        }
                        Text("Account details for \(selectedAccount!.name) - \(selectedAccount!.id)")
                            .font(.custom("Nunito-Regular", size: 24))
                            .fontWeight(.bold)
                            .padding()
                        
                        // Add the rest of your content for the account details page here...
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Background"))
                }
                
                if (selectedAccount != nil && isCreateNoteTrigger) {
                    // Account details page
                    VStack {
                        Button("Dismiss") {
                            selectedAccount = nil
                            isCreateNoteTrigger = false
                        }
                        Text("Create Note for \(selectedAccount!.name) - \(selectedAccount!.id)")
                            .font(.custom("Nunito-Regular", size: 24))
                            .fontWeight(.bold)
                            .padding()
                        
                        // Add the rest of your content for the account details page here...
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Background"))
                }
            }
        }
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
