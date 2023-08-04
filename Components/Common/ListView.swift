//
//  ListView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//


import SwiftUI

/**
 A custom `View` that displays a list of hashes using `ListElementView`. The list can be refreshed by calling the `loadData` closure, and can be cleared by calling the `clearData` closure. A loading indicator is displayed at the bottom of the list when `isLoadingPage` is `true`.
 */
struct ListView: View {
    // The hashes to display in the list
    var hashes: [String]
    
    // A Boolean value indicating whether the list is currently loading more data
    var isLoadingPage: Bool
    
    // A closure to load more data into the list
    var loadData: () -> Void
    
    // A closure to clear the data from the list
    var clearData: () -> Void
    
    /**
     Initializes a new instance of `ListView`.
     
     - Parameters:
     - hashes: The hashes to display in the list.
     - isLoadingPage: A Boolean value indicating whether the list is currently loading more data.
     - loadData: A closure to load more data into the list.
     - clearData: A closure to clear the data from the list.
     */
    init(hashes: [String], isLoadingPage: Bool, loadData: @escaping () -> Void, clearData: @escaping () -> Void) {
        self.hashes = hashes
        self.isLoadingPage = isLoadingPage
        self.loadData = loadData
        self.clearData = clearData
    }
    
    // The body of the view
    var body: some View {
        ZStack {
            // The list of hashes to display
            List {
                ForEach(Array(hashes.enumerated()), id: \.offset) { index, hash in
                    ZStack(alignment: .top){
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .bottom)
                            .foregroundColor(.gray)
                            .zIndex(1)
                        ListElementView(id: hash)
                            .padding(.vertical, 15)
                            .onAppear {
                                if hashes.last == hash {
                                    loadData()
                                }
                            }
                        
                        
                    }
                    
                }
                .background(.gray)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                HStack(spacing: 0) {
                    Spacer()
                    if(isLoadingPage && !hashes.isEmpty) {
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .background(.gray)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .environment(\.defaultMinListRowHeight, 1)
            .listStyle(.plain)
            .background(.gray)
            .refreshable {
                clearData()
                loadData()
            }
            .onAppear {
                loadData()
            }
            .overlay {
                /// The loading indicator until the list is loaded for the first time and no results found message if the list is empty
                if(isLoadingPage) {
                    Text("Loading...")
                        .foregroundColor(.white)
                        .background(.gray)
                        .font(.system(size: 20, weight: .bold))
                } else if(hashes.isEmpty){
                    Text("No Results Found")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
    }
}
