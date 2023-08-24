//
//  SuggestedTaskView.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 23/08/23.
//

import SwiftUI

struct SuggestedTaskCardView: View {
    var accountId: String
    var suggestion: SuggestionStruct
    
    
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @State var recommendedText: String
    @State var selectedDate: Date = Date.now
    @State var assignedToUsername: String = ""
    @State var selectedUserId: String = ""
    @State var isAddTaskInProgress = false
    @State var isTaskSaved = false
    @State var showEditTaskView = false
    @State private var isDatePickerVisible = false
    @State private var showUserSearchView: Bool = false
    @FocusState private var focusedRecommendedText: Bool
    @FocusState private var userSelected: Bool
    
    init(accountId: String, suggestion: SuggestionStruct) {
        self.accountId = accountId
        self.suggestion = suggestion
        _recommendedText = State(initialValue: suggestion.description)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format of your due_date
        if let date = dateFormatter.date(from: suggestion.due_date) {
            _selectedDate = State(initialValue: date)
        } else {
            _selectedDate = State(initialValue: Date()) // Default value if conversion fails
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                // text editor component
                HStack{
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
                    
                    Spacer()
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
                                Text("\(BasicHelper.getInitials(from: assignedToUsername))")
                                    .frame(width: 12, height:18)
                                    .font(.custom("Nunito-Bold", size: 5.24))
                                    .foregroundColor(.black)
                                    .background(Color("UserBubble"))
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .accessibilityIdentifier("txt_account_detail_note_creator_initials")
                                
                                Text(assignedToUsername)
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
                                assignedToUsername = userId
                                selectedUserId = userName
                            })
                        }
                        .accessibilityIdentifier("btn_create_note_search_user")
                        
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
                            if(selectedDate != Date()){
                                Text("Select")
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                
                                Image("CalendarCheck")
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 6)
                            }
                            else {
                                Text("\((selectedDate.formatted(date: .numeric, time: .omitted)))")
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
                            // Remove this card from ids array
                            createNoteScreenViewModel.removeSuggestion(suggestion)
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
                // TODO: Remove this as after success of save note API, this must be triggered internally
            }
            .padding()
            // Add dotted border
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [1,5])) // Specify the dash pattern here
                    .foregroundColor(Color("TextPrimary").opacity(0.5))
            )
            .background(
                NavigationLink(
                    destination: CreateTaskScreen(isPresented: $showEditTaskView,
                                                  accountId: accountId,
                                                  description: $recommendedText,
                                                 dueDate: $selectedDate,
                                                 crmOrganizationUserId: $selectedUserId)
                    .navigationBarBackButtonHidden(true),
                    isActive: self.$showEditTaskView
                ) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
}
