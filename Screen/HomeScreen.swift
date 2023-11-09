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
    @StateObject var createEventViewModel = CreateEventViewModel()
    @StateObject var accountDetailViewModel = AccountDetailScreenViewModel()
    @StateObject var taskDetailScreenViewModel = TaskDetailScreenViewModel()
    @StateObject var eventDetailScreenViewModel = EventDetailScreenViewModel()
    @StateObject var createAccountScreenViewModel = CreateAccountScreenViewModel()
    @State private var showUserSearchView: Bool = false
    
    var body: some View {
        NavigationStack {
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
            .background(Color(Asset.background.name))
            .onAppear {
                createAccountScreenViewModel.fetchAccountFields(onSuccess: {})
            }
        }
        .navigationViewStyle(.stack)
        .environmentObject(acccountSearchViewModelObject)
        .environmentObject(userSearchViewModelObject)
        .environmentObject(acccountDetailScreenViewModelObject)
        .environmentObject(createNoteViewModel)
        .environmentObject(noteDetailScreenViewModel)
        .environmentObject(acccountListViewModelObject)
        .environmentObject(createTaskViewModel)
        .environmentObject(createEventViewModel)
        .environmentObject(accountDetailViewModel)
        .environmentObject(taskDetailScreenViewModel)
        .environmentObject(eventDetailScreenViewModel)
        .environmentObject(createAccountScreenViewModel)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
