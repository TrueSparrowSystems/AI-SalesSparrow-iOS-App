//
//  UserSearchView.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 21/08/23.
//

import SwiftUI

struct UserSearchView: View {
    @EnvironmentObject var userSearchViewModel: UserSearchViewModel
    @State private var searchText = ""
    
    @Binding var isPresented: Bool // This binding will control the presentation of the sheet
    
    var onUserSelect: ((String, String) -> Void)? // Callback function to handle account selection
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .accessibilityIdentifier("img_search_magnifying_glass")
                
                TextField("", text: $searchText,
                          prompt: Text("Search Users").foregroundColor(Color("SearchPrimary").opacity(0.8)))
                .font(.custom("Nunito-Regular", size: 16).weight(.regular))
                .foregroundColor(Color("LuckyPoint"))
                .accessibilityIdentifier("text_field_search_account")
                .focused($focused)
            }
            .frame(height: 66)
            .padding(.horizontal)
            .opacity(0.6)
            .onChange(of: searchText) { newValue in
                // Call the function from the view model whenever searchText changes
                userSearchViewModel.fetchData(newValue)
            }
            
            // Divider Line
            Divider()
                .background(Color("SearchPrimary"))
                .opacity(0.6)
            
            if(userSearchViewModel.isSearchUserInProgress){
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color("LoginButtonSecondary"))
                    .controlSize(.large)
            }
            else if(userSearchViewModel.userListData.user_ids.count > 0){
                // List of users
                UserListView(
                    listData: userSearchViewModel.userListData,
                    userIds: userSearchViewModel.userListData.user_ids,
                    isPresented: $isPresented,
                    removeSearchTextFocus: removeSearchTextFocus,
                    onScroll: onScroll
                )
            }
            else{
                Text("No Result Found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .accessibilityIdentifier("txt_search_no_result_found")
            }
        }
        .onAppear {
            userSearchViewModel.fetchData("")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
        .background(Color("Background"))
    }
    
    func removeSearchTextFocus() -> Void {
        focused = false
    }
    func onScroll(_: DragGesture.Value) -> Void {
        focused = false
    }
}

struct UserListView: View {
    var listData: SearchUserStruct
    var userIds: [String]
    var onUserSelect: ((String, String) -> Void)?
    @Binding var isPresented: Bool
    var removeSearchTextFocus: (() -> Void)
    var onScroll: ((DragGesture.Value) -> Void)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                ForEach(userIds, id: \.self) { userId in
                    if let user = listData.user_map_by_id[userId] {
                        HStack (alignment: .center) {
                            Text("\(BasicHelper.getInitials(from: user.name))")
                                .frame(width: 20, height: 20)
                                .font(.custom("Nunito-Bold", size: 5.24))
                                .foregroundColor(.black)
                                .background(Color("UserBubble"))
                                .clipShape(RoundedRectangle(cornerRadius: 26))
                                .accessibilityIdentifier("txt_account_detail_note_creator_initials")
                            
                            HStack {
                                Text(user.name)
                                    .font(.custom("Nunito-Medium", size: 14))
                                    .foregroundColor(Color("SearchPrimary"))
                                    .accessibilityIdentifier("txt_search_account_name_\(user.name)")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier("btn_search_account_name_\(user.name)")
                            .onTapGesture {
                                isPresented = false // Dismiss the sheet
                                removeSearchTextFocus()
                                onUserSelect?(userId, user.name)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                        // Divider Line
                        Divider()
                            .background(Color("SearchPrimary"))
                            .opacity(0.6)
                        
                    }
                }
            }
        }
        .simultaneousGesture(
            DragGesture().onChanged(
                onScroll
            )
        )
    }
}
