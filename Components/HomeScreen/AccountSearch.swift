//
//  AccountSearch.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct AccountSearchView: View {
    @StateObject private var viewModel = SearchAccountViewModel()
    @State private var searchText = ""
    var forAccountSearch: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search Accounts", text: $searchText)
                    .font(.custom("Nunito-Regular",size: 16))
                    .foregroundColor(Color("SearchPrimary"))
                    .opacity(0.8)
            }
            .frame(height: 66)
            .padding()
            .opacity(0.6)
            
            // Divider Line
            Divider()
                .background(Color("SearchPrimary"))
                .opacity(0.6)
            
            // List of Accounts
            List(viewModel.listData.filter { searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText) }) { account in
                VStack() {
                    HStack{
                        Text(account.name)
                            .font(.custom("Nunito-Regular",size: 16))
                            .foregroundColor(Color("SearchPrimary"))
                        
                        Spacer()
                        if forAccountSearch {
                            Text("Add Note")
                                .font(.custom("Nunito-Regular",size: 16))
                                .foregroundColor(Color("LoginButtonPrimary"))
                                .frame(width: 72.0, height: 28.0)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct AccountSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSearchView()
    }
}
