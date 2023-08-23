//
//  CreateNoteScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import SwiftUI

struct CreateNoteScreen : View {
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var text: String = ""
    @State var recommendedText: String = "Presentation to plan a migration from PHP to Ruby."
    @State var isSaveInProgress = false
    @State var isAddTaskInProgress = false
    @State var isNoteSaved = false
    @State var isTaskSaved = false
    @State var accountId = ""
    @State var accountName = ""
    @State var isAccountSelectable = true
    @State var showAccountSearchView = false
    @State var isPopoverVisible = false
    @FocusState private var focused: Bool
    @FocusState private var userSelected: Bool
    @FocusState private var focusedRecommendedText: Bool
    @State private var showUserSearchView: Bool = false
    @State var selectedUserName: String = ""
    @State var selectedUserId: String = ""
    
    var body: some View {
        ScrollView{
            HStack(alignment: .center){
                Text(isNoteSaved ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier(isNoteSaved ? "btn_done_create_note" : "btn_cancel_create_note")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    isSaveInProgress = true
                    createNoteScreenViewModel.createNote(text: text,accountId: accountId, onSuccess: {
                        isSaveInProgress = false
                        isNoteSaved = true
                    }, onFailure: {
                        isSaveInProgress = false
                    })
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(isSaveInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            Text("Saving")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_saving")
                            
                        }else if(isNoteSaved){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_saved")
                        }else{
                            Image("SalesforceIcon")
                                .resizable()
                                .frame(width: 17, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_salesforce_icon")
                            
                            Text("Save")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_save")
                        }
                    }
                    .frame(width: 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_note")
                .disabled(isNoteSaved || isSaveInProgress || accountId == "" || text == "")
                .opacity(accountId == "" || text == "" ? 0.7 : 1)
            }
            .padding(.vertical, 12)
            
            HStack{
                Image("AccountIcon")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .accessibilityIdentifier("img_create_note_account_icon")
                
                Text("Account")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-Regular", size: 12))
                    .accessibilityIdentifier("txt_create_note_account")
                if(isAccountSelectable && !(isNoteSaved || isSaveInProgress)){
                    HStack(alignment: .center){
                        Text(accountId == "" ? "Select": accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Light", size: 14))
                            .accessibilityIdentifier(accountId == "" ? "txt_create_note_select_account" : "txt_create_note_selected_account")
                        Image("ArrowDown")
                            .frame(width: 7, height: 4)
                            .padding(.trailing, 6)
                    }
                    .accessibilityIdentifier("btn_select_account")
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        showAccountSearchView = true
                    }
                    .sheet(isPresented: $showAccountSearchView, onDismiss: {
                    }) {
                        AccountSearchView(isPresented: $showAccountSearchView, isCreateNoteFlow: true, onNoteCreateSelected: { _accountId, _accountName in
                            accountId = _accountId
                            accountName = _accountName
                        })
                    }
                    
                }else{
                    HStack(alignment: .center){
                        Text(accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 14))
                            .accessibilityIdentifier("cn_selected_account")
                    }
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.top, 12)
            
            HStack{
                if(isNoteSaved || isSaveInProgress){
                    Text(text)
                        .foregroundColor(Color("TextPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Nunito-SemiBold", size: 18))
                    
                }else{
                    TextField("Add Note",text: $text, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_create_note")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                    
                }
            }
            .contentShape(Rectangle())
            
            if(isNoteSaved){
                HStack{
                    Image("Sparkle")
                    Text("We have some recommendations")
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 16))
                    Spacer()
                    Button{
                        isPopoverVisible.toggle()
                    } label: {
                        Image("AddIcon")
                            .frame(width: 20, height: 20)
                    }
                    .overlay{
                        if isPopoverVisible {
                            AddButtonPopoverComponent(isPopoverVisible: $isPopoverVisible)
                                .offset(x: -55,y: 55)
                        }
                    }
                }
                
                VStack{
                    // text editor component
                    // update text value from view model
                    // TODO: Update to different state
                    TextField("Add Note",text: $recommendedText, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focusedRecommendedText)
                        .accessibilityIdentifier("et_create_note")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    
                    // assign to component + picker
                    HStack{
                        HStack {
                            Text("Assign to")
                                .foregroundColor(Color("TextPrimary"))
                                .font(.custom("Nunito-SemiBold", size: 12))
                                .padding()
                            
                            // add verticle divider gray line
                            VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                                .padding(.vertical)
                            
                            Button(action: {
                                // Toggle user search view
                                showUserSearchView = true
                            }){
                                if(!userSelected){
                                    Text("Select")
                                        .foregroundColor(Color("RedHighlight"))
                                        .font(.custom("Nunito-Bold", size: 12))
                                    
                                    Image("ArrowDown")
                                        .frame(width: 6, height: 3)
                                        .padding(.trailing, 6)
                                } else {
                                    Text("\(BasicHelper.getInitials(from: selectedUserName))")
                                        .frame(width: 12, height:18)
                                        .font(.custom("Nunito-Bold", size: 5.24))
                                        .foregroundColor(.black)
                                        .background(Color("UserBubble"))
                                        .clipShape(RoundedRectangle(cornerRadius: 26))
                                        .accessibilityIdentifier("txt_account_detail_note_creator_initials")
                                    
                                    Text(selectedUserName)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 6)
                                        .foregroundColor(Color("RedHighlight"))
                                        .font(.custom("Nunito-Light", size: 12))
                                        .accessibilityIdentifier("txt_create_note_username")
                                }
                               
                            }
                            .sheet(isPresented: $showUserSearchView){
                                UserSearchView(isPresented: $showUserSearchView,
                                               onUserSelect: { userId, userName in
                                    selectedUserName = userId
                                    selectedUserId = userName
                                })
                            }
                            .accessibilityIdentifier("btn_create_task_search_user")
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                        
                        Spacer()
                    }
                    
                    // due date component + picker
                    HStack{
                        HStack {
                            Text("Due")
                                .foregroundColor(Color("TextPrimary"))
                                .font(.custom("Nunito-SemiBold", size: 12))
                                .padding()
                            
                            // add verticle divider gray line
                            VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                                .padding(.vertical)
                            
                            Button(action: {
                                // Toggle user search view
                            }){
                                Text("Select")
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                
                                Image("CalendarCheck")
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 6)
                            }
                            .padding()
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                        
                        Spacer()
                    }
                    // action buttons + view model
                    if(!isTaskSaved){
                        HStack{
                            Button(action: {
                                isAddTaskInProgress = true
                                // TODO: call create task view model
                                createNoteScreenViewModel.createNote(text: text,accountId: accountId, onSuccess: {
                                    isAddTaskInProgress = false
                                    isTaskSaved = true
                                }, onFailure: {
                                    isAddTaskInProgress = false
                                })
                            }, label:{
                                HStack(alignment: .center, spacing: 0){
                                    if(isAddTaskInProgress){
                                        ProgressView()
                                            .tint(Color("LoginButtonPrimary"))
                                            .controlSize(.small)
                                        Text("Adding Task...")
                                            .foregroundColor(.white)
                                            .font(.custom("Nunito-Medium", size: 12))
                                            .accessibilityIdentifier("txt_create_note_adding_task")
                                        
                                    } else{
                                        Text("Add Task")
                                            .foregroundColor(.white)
                                            .font(.custom("Nunito-Medium", size: 12))
                                            .accessibilityIdentifier("txt_create_note_add_task")
                                    }
                                }
                                .frame(width: 68, height: 32)
                                .background(
                                    Color(hex: "SaveButtonBackground")
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                            .accessibilityIdentifier("btn_create_note_add_task")
                            
                            Button(action: {
                                // TODO: Add action to disappear view
                            }, label:{
                                HStack(alignment: .center, spacing: 0){
                                    Text("Cancel")
                                        .foregroundColor(Color("CancelText"))
                                        .font(.custom("Nunito-Medium", size: 12))
                                        .accessibilityIdentifier("txt_create_note_cancel")
                                }
                                .frame(width: 68, height: 32)
                                .background(Color("Background"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                            .accessibilityIdentifier("btn_create_note_cancel")
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#5D678D"), lineWidth: 1))
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5])) // Specify the dash pattern here
                        .foregroundColor(Color("BorderColor"))
                )
                
            }
            
        }
        .gesture(DragGesture().onChanged{_ in
            if(isPopoverVisible){
                isPopoverVisible.toggle()
            }else{
                focused = false
            }
        })
        .contentShape(Rectangle())
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(Color("Background"))
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
        .onTapGesture {
            if(isPopoverVisible){
                isPopoverVisible.toggle()
            }else{
                focused = false
            }
        }
    }
}
