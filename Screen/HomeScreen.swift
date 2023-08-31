//
//  HomeScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 02/08/23.
//

import SwiftUI

struct HomeScreen: View {
    @State private var showCreateNoteAccountSearchView: Bool = false
    @StateObject var acccountListViewModelObject = AccountListViewModel()
    @StateObject var acccountSearchViewModelObject = AccountSearchViewModel()
    @StateObject var userSearchViewModelObject = UserSearchViewModel()
    @StateObject var acccountDetailScreenViewModelObject = AccountDetailViewScreenViewModel()
    @StateObject var createNoteViewModel = CreateNoteScreenViewModel()
    @StateObject var noteDetailScreenViewModel = NoteDetailScreenViewModel()
    @StateObject var createTaskViewModel = CreateTaskViewModel()
    @State private var showUserSearchView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Bar
                TopBar()
                
                // List of Accounts
                AccountList()
                    .padding(.top)
                
                // Bottom Bar with + Button
                BottomBar()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color("Background"))
            
        }
        .navigationViewStyle(.stack)
        .environmentObject(acccountSearchViewModelObject)
        .environmentObject(userSearchViewModelObject)
        .environmentObject(acccountDetailScreenViewModelObject)
        .environmentObject(createNoteViewModel)
        .environmentObject(noteDetailScreenViewModel)
        .environmentObject(acccountListViewModelObject)
        .environmentObject(createTaskViewModel)
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
