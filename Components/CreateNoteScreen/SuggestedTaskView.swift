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
    var index: Int
    
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @EnvironmentObject var createTaskViewModel : CreateTaskViewModel
    @State var recommendedText: String
    @State var selectedDate: Date
    @State var assignedToUsername: String = ""
    @State var selectedUserId: String = ""
    @State var isTaskSaved = false
    @State var showEditTaskView = false
    @State private var isDateSelected = false
    @State private var showUserSearchView: Bool = false
    @State var taskId: String = ""
    @FocusState private var focusedRecommendedText: Bool
    @FocusState private var userSelected: Bool
    
    init(accountId: String,suggestion: SuggestionStruct, index: Int) {
        self.accountId = accountId
        self.suggestion = suggestion
        self.index = index
        _recommendedText = State(initialValue: suggestion.description)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format of your due_date
        if let date = dateFormatter.date(from: suggestion.due_date ?? "") {
            _selectedDate =  State(initialValue: date)
            _isDateSelected =  State(initialValue: true)
        } else {
            _selectedDate =  State(initialValue: Date())
            _isDateSelected =  State(initialValue: false)
        }
    }
    
    var body: some View {
        if isTaskSaved{
            SavedTaskCard(recommendedText: recommendedText, selectedDate: selectedDate, assignedToUsername: assignedToUsername, index: index, accountId: accountId, taskId: taskId)
        }else{
            VStack{
                // text editor component
                HStack{
                    Text("\(recommendedText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 16))
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("txt_create_note_suggestion_title_index_\(index)")
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                        .background(Color("GhostWhite").opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Do nothing. Kept on tap here to override tap action over parent tap action
                    showEditTaskView = true
                }
                
                // assign to component + picker
                HStack{
                    HStack {
                        Text("Assign to")
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                        
                        Button(action: {
                            // Toggle user search view
                            showUserSearchView = true
                        }){
                            if(assignedToUsername.isEmpty){
                                Text("Select")
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                    .tracking(0.5)
                                
                                Image("ArrowDown")
                                    .frame(width: 6, height: 3)
                                    .padding(.trailing, 6)
                            } else {
                                Text(BasicHelper.getInitials(from: assignedToUsername))
                                    .frame(width: 18, height: 18)
                                    .font(.custom("Nunito-Bold", size: 6))
                                    .foregroundColor(Color.white)
                                    .background(Color("UserBubble"))
                                    .clipShape(RoundedRectangle(cornerRadius: 47))
                                    .accessibilityIdentifier("img_user_account_detail_user_initials")
                                
                                Text(assignedToUsername)
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                    .accessibilityIdentifier("txt_create_note_suggestion_user_index_\(index)")
                                    .tracking(0.5)
                                
                                Image("ArrowDown")
                                    .frame(width: 6, height: 3)
                                    .padding(.trailing, 6)
                            }
                            
                        }
                        .sheet(isPresented: $showUserSearchView){
                            UserSearchView(isPresented: $showUserSearchView,
                                           onUserSelect: { userId, userName in
                                assignedToUsername = userName
                                selectedUserId = userId
                            })
                        }
                        .accessibilityIdentifier("btn_create_note_search_user_index_\(index)")
                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    
                    Spacer()
                }
                
                // due date component + picker
                HStack{
                    HStack{
                        Text("Due")
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                        
                        
                        ZStack{
                            DatePickerView(selectedDate: $selectedDate, onTap: {
                                isDateSelected = true
                            })
                            .background(.white)
                            .cornerRadius(8)
                            
                            if(!isDateSelected){
                                HStack (spacing: 0) {
                                    Text("Select Date")
                                        .foregroundColor(Color("TermsPrimary"))
                                        .font(.custom("Nunito-Light", size: 12))
                                        .tracking(0.5)
                                        .padding(0)
                                    
                                    Image("EmptyCalendar")
                                        .frame(width: 15, height: 15)
                                        .padding(.leading, 6)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.white)
                                .userInteractionDisabled()
                                
                            }
                            else{
                                HStack (spacing: 0) {
                                    Text(BasicHelper.getDateStringFromDate(from: selectedDate))
                                        .foregroundColor(Color("TermsPrimary"))
                                        .font(.custom("Nunito-Bold", size: 12))
                                        .tracking(0.5)
                                        .padding(0)
                                    
                                    Image("EmptyCalendar")
                                        .frame(width: 15, height: 15)
                                        .padding(.leading, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.white)
                                .userInteractionDisabled()
                            }
                        }
                    }
                    .frame(width: 170, height: 20)
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 0))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    Spacer()
                }
                .accessibilityIdentifier("btn_create_note_due")
                
                // action buttons + view model
                if(!isTaskSaved){
                    HStack{
                        Button(action: {
                            createTaskViewModel.createTask(accountId: accountId, assignedToName: assignedToUsername, crmOrganizationUserId: selectedUserId, description: recommendedText, dueDate: selectedDate){taskId in
                                self.taskId = taskId
                                isTaskSaved = true
                            }
                        }, label:{
                            HStack(alignment: .center, spacing: 0){
                                if(createTaskViewModel.isCreateTaskInProgress){
                                    ProgressView()
                                        .tint(Color("LoginButtonPrimary"))
                                        .controlSize(.small)
                                    Text("Adding Task...")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Medium", size: 12))
                                        .accessibilityIdentifier("txt_create_note_adding_task_\(index)")
                                    
                                } else{
                                    Text("Add Task")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Medium", size: 12))
                                        .accessibilityIdentifier("txt_create_note_add_task_index_\(index)")
                                }
                            }
                            .frame(width: createTaskViewModel.isCreateTaskInProgress ? 115 : 72, height: 32)
                            .background(
                                Color(hex: "SaveButtonBackground")
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .disabled(accountId.isEmpty || recommendedText.isEmpty || selectedUserId.isEmpty || !isDateSelected || createTaskViewModel.isCreateTaskInProgress)
                        .opacity(accountId.isEmpty || recommendedText.isEmpty || selectedUserId.isEmpty || !isDateSelected ? 0.7 : 1)
                        .accessibilityIdentifier("btn_create_note_add_task_\(index)")
                        
                        Button(action: {
                            
                            AlertViewModel.shared.showAlert(_alert: Alert(
                                title: "Remove Task Suggestion",
                                message: Text("Are you sure you want to remove this task suggestion?"),
                                submitText: "Remove",
                                onSubmitPress: {
                                    createNoteScreenViewModel.removeSuggestion(at: index)
                                    self.recommendedText = ""
                                    self.selectedDate = Date.now
                                }
                            ))
                            
                            
                        }, label:{
                            HStack(alignment: .center, spacing: 0){
                                Text("Cancel")
                                    .foregroundColor(Color("CancelText"))
                                    .font(.custom("Nunito-Medium", size: 12))
                                    .accessibilityIdentifier("txt_create_note_cancel")
                            }
                            .frame(width: 72, height: 32)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .accessibilityIdentifier("btn_create_note_cancel_\(index)")
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#5D678D"), lineWidth: 1))
                        
                        Spacer()
                    }
                    .padding(.top, 16)
                }
            }
            .onChange(of: createNoteScreenViewModel.suggestedTaskData, perform: {_ in
                let suggestion = createNoteScreenViewModel.suggestedTaskData.add_task_suggestions[self.index]
                self.recommendedText = suggestion.description
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Format of your due_date
                if let date = dateFormatter.date(from: suggestion.due_date ?? "") {
                    self.selectedDate =  date
                    self.isDateSelected =  true
                } else {
                    self.selectedDate =  Date()
                    self.isDateSelected =  false
                }
            })
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1,5])) // Specify the dash pattern here
                    .foregroundColor(Color("TextPrimary"))
            )
            .background(
                NavigationLink(
                    destination: CreateTaskScreen(accountId: accountId,
                                                  description: $recommendedText,
                                                  dueDate: $selectedDate,
                                                  crmOrganizationUserId: $selectedUserId, isDateSelected: $isDateSelected, selectedUserName: $assignedToUsername, isTaskSaved: $isTaskSaved, taskId: $taskId),
                    isActive: self.$showEditTaskView
                ) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
    
}

struct SavedTaskCard : View {
    var recommendedText: String
    var selectedDate: Date
    var assignedToUsername: String = ""
    var index: Int
    var accountId: String
    var taskId: String
    @State var isPopoverVisible: Bool = false
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    
    var body : some View {
        VStack {
            VStack {
                HStack{
                    Text(BasicHelper.getInitials(from: UserStateViewModel.shared.currentUser.name))
                        .frame(width: 18, height: 18)
                        .font(.custom("Nunito-Bold", size: 6))
                        .foregroundColor(Color.white)
                        .background(Color("UserBubble"))
                        .clipShape(RoundedRectangle(cornerRadius: 47))
                        .accessibilityIdentifier("img_creator_user_initials")
                    
                    Text(UserStateViewModel.shared.currentUser.name)
                        .foregroundColor(Color("TermsPrimary"))
                        .font(.custom("Nunito-Medium", size: 14))
                        .accessibilityIdentifier("txt_add_task_creator_user")
                        .tracking(0.5)
                    
                    Spacer()
                    Text("Just Now")
                        .foregroundColor(Color("TermsPrimary"))
                        .font(.custom("Nunito-Light", size: 12))
                        .accessibilityIdentifier("txt_created_timestamp")
                        .tracking(0.5)
                    
                    Button{
                        isPopoverVisible.toggle()
                    } label: {
                        Image("DotsThreeOutline")
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .foregroundColor(Color("TextPrimary"))
                    }
                    .accessibilityIdentifier("btn_create_note_task_more_\(index)")
                    
                }
                Text("\(recommendedText)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("PortGore"))
                    .font(.custom("Nunito-SemiBold", size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("txt_create_note_task_description")
                    .padding(6)
                    .background(Color("AliceBlue"))
                    .cornerRadius(6)
                
                HStack{
                    HStack {
                        Text("Assign to")
                            .foregroundColor(Color("PortGore"))
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("PortGore").opacity(0.5))
                        
                        Text(BasicHelper.getInitials(from: assignedToUsername))
                            .frame(width: 18, height: 18)
                            .font(.custom("Nunito-Bold", size: 6))
                            .foregroundColor(Color.white)
                            .background(Color("UserBubble"))
                            .clipShape(RoundedRectangle(cornerRadius: 47))
                            .accessibilityIdentifier("img_user_account_detail_user_initials")
                        
                        Text(assignedToUsername)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .accessibilityIdentifier("txt_add_task_selected_user")
                            .tracking(0.5)
                        
                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    .background(Color("GhostWhite"))
                    .cornerRadius(6)
                    
                    Spacer()
                }
                .padding(.vertical, 6)
                
                HStack{
                    HStack {
                        Text("Due")
                            .foregroundColor(Color("PortGore"))
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("PortGore").opacity(0.5))
                        
                        
                        Text(BasicHelper.getDateStringFromDate(from: selectedDate))
                            .foregroundColor(Color("PortGore"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .tracking(0.5)
                            .padding(0)
                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    .background(Color("GhostWhite"))
                    .cornerRadius(6)
                    
                    Spacer()
                }
            }
            .padding()
            .overlay(alignment: .topTrailing){
                if isPopoverVisible {
                    VStack {
                        Button(action: {
                            isPopoverVisible = false
                            
                            AlertViewModel.shared.showAlert(_alert: Alert(
                                title: "Delete Task",
                                message: Text("Are you sure you want to delete this task?"),
                                submitText: "Delete",
                                onSubmitPress: {
                                    acccountDetailScreenViewModelObject.deleteTask(accountId: accountId, taskId: taskId){
                                        createNoteScreenViewModel.removeSuggestion(at: index)
                                    }
                                }
                            ))
                        }){
                            HStack{
                                Image("DeleteIcon")
                                    .frame(width: 20, height: 20)
                                Text("Delete")
                                    .font(.custom("Nunito-SemiBold",size: 16))
                                    .foregroundColor(Color("TextPrimary"))
                            }
                        }
                        .accessibilityIdentifier("btn_account_detail_delete_task_\(index)")
                    }
                    .padding(10)
                    .cornerRadius(4)
                    .frame(width: 100, height: 40)
                    .background(Color("CardBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color("CardBorder"), lineWidth: 1)
                    )
                    .offset(x: -14, y: 32)
                }
            }
            .background(.white)
            
            HStack{
                Image("CheckWithGreenTick")
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Text("Task Added")
                    .foregroundColor(Color("PortGore"))
                    .font(.custom("Nunito-SemiBold", size: 12))
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color("BorderColor")), alignment: .top)
            .background(Color("PastelGreen").opacity(0.2))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("BorderColor"), lineWidth: 1))
        
    }
}

struct SavedTaskCard_Previews: PreviewProvider {
    static var previews: some View {
        SavedTaskCard(recommendedText: "Hello text", selectedDate: Date(), assignedToUsername: "some user", index: 0, accountId: "sdfg34rf", taskId: "sdf234rtgv")
    }
}
