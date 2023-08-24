//
//  SuggestedTaskView.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 23/08/23.
//

import SwiftUI

struct SuggestedTaskView: View {
    var text: String
    @Binding var cancelSuggestedTask: Bool
    @State var recommendedText: String = ""
    @FocusState private var userSelected: Bool
    @State private var showUserSearchView: Bool = false
    @State var selectedUserName: String = ""
    @State var selectedUserId: String = ""
    @State var isAddTaskInProgress = false
    @State var isTaskSaved = false
    @FocusState private var focusedRecommendedText: Bool
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @State var showEditTaskView = false
    @State private var isDatePickerVisible = false
    @State var selectedDate: Date? = Date.now
    
    var body: some View {
        ZStack{
            VStack{
                // text editor component
                Text("\(recommendedText)")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-SemiBold", size: 16))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("et_create_note")
                    .onTapGesture {
                        // Do nothing. Kept on tap here to override tap action over parent tap action
                        showEditTaskView = true
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    .sheet(isPresented: $showEditTaskView) {
                        // Display Task create View and pass recommended text to editor.
                    }
                
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
                            // Toggle DateTimePicker
                            isDatePickerVisible = true
                        }){
                            if(selectedDate == nil){
                                Text("Select")
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                
                                Image("CalendarCheck")
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 6)
                            }
                            else {
                                Text("\((selectedDate?.formatted(date: .numeric, time: .omitted))!)")
                                    .foregroundColor(Color(hex: "#444A62"))
                                    .font(.custom("Nunito-Bold", size: 12))
                            }
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
                            .frame(width: isAddTaskInProgress ? 115 : 72, height: 32)
                            .background(
                                Color(hex: "SaveButtonBackground")
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .accessibilityIdentifier("btn_create_note_add_task")
                        
                        Button(action: {
                            // TODO: Add action to disappear view
                            cancelSuggestedTask = true
                        }, label:{
                            HStack(alignment: .center, spacing: 0){
                                Text("Cancel")
                                    .foregroundColor(Color("CancelText"))
                                    .font(.custom("Nunito-Medium", size: 12))
                                    .accessibilityIdentifier("txt_create_note_cancel")
                            }
                            .frame(width: 72, height: 32)
                            .background(Color("Background"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .accessibilityIdentifier("btn_create_note_cancel")
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#5D678D"), lineWidth: 1))
                        
                        Spacer()
                    }
                }
            }
            .onAppear {
                createNoteScreenViewModel.generateSuggestion(text: text, onSuccess: {
                    recommendedText = createNoteScreenViewModel.suggestedTaskData.text
                }, onFailure: {
                    recommendedText = "Presentation to plan a migration from PHP to Ruby. \n\n\n Yoooooooooooo \n"
                })
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [1,5])) // Specify the dash pattern here
                    .foregroundColor(Color("TextPrimary").opacity(0.5))
            )
            
            if(isDatePickerVisible){
                DatePickerView(selectedDate: Binding($selectedDate)!)
                    .onChange(of: selectedDate, perform: { newDate in
                        // Close the DatePicker after a date is selected
                        isDatePickerVisible = false
                    })
            }
        }
    }
}
