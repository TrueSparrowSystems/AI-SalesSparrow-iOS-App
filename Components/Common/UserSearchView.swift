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
                Image(Asset.magnifyingGlass.name)
                    .accessibilityIdentifier("img_search_magnifying_glass")
                
                TextField("", text: $searchText,
                          prompt: Text("Search Users").foregroundColor(Color(Asset.searchPrimary.name).opacity(0.8)))
                .font(.nunitoRegular(size: 16))
                .foregroundColor(Color(Asset.luckyPoint.name))
                .accessibilityIdentifier("txt_search_user_field")
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
                .background(Color(Asset.searchPrimary.name))
                .opacity(0.6)
            
            if userSearchViewModel.isSearchUserInProgress {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color(Asset.loginButtonSecondary.name))
                    .controlSize(.large)
            } else if userSearchViewModel.userListData.crm_organization_user_ids.count > 0 {
                // List of users
                UserListView(
                    listData: userSearchViewModel.userListData,
                    userIds: userSearchViewModel.userListData.crm_organization_user_ids,
                    onUserSelect: onUserSelect,
                    isPresented: $isPresented,
                    removeSearchTextFocus: removeSearchTextFocus,
                    onScroll: onScroll
                )
            } else {
                Text("No Result Found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .accessibilityIdentifier("txt_search_user_no_result_found")
            }
        }
        .onAppear {
            userSearchViewModel.fetchData("")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focused = true
            }
        }
        .background(Color(Asset.background.name))
    }
    
    func removeSearchTextFocus() {
        focused = false
    }
    func onScroll(_: DragGesture.Value) {
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
            VStack(spacing: 0) {
                ForEach(userIds, id: \.self) { userId in
                    if let user = listData.crm_organization_user_map_by_id[userId] {
                        HStack(alignment: .center) {
                            Text("\(BasicHelper.getInitials(from: user.name))")
                                .frame(width: 20, height: 20)
                                .font(.nunitoBold(size: 6))
                                .foregroundColor(.black)
                                .background(Color(Asset.userBubble.name))
                                .clipShape(RoundedRectangle(cornerRadius: 26))
                                .accessibilityIdentifier("txt_search_user_user_initials_\(user.name)")
                            
                            HStack {
                                Text(user.name)
                                    .font(.nunitoMedium(size: 14))
                                    .foregroundColor(Color(Asset.searchPrimary.name))
                                    .accessibilityIdentifier("txt_search_user_user_name_\(user.name)")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier("btn_search_user_user_name_\(user.name)")
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
                            .background(Color(Asset.searchPrimary.name))
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
