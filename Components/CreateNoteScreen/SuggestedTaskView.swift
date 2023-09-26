//
//  SuggestedTaskView.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 23/08/23.
//

import SwiftUI

struct SuggestedTaskCardView: View {
    var accountId: String
    var suggestion: TaskSuggestionStruct
    var index: Int
    
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    @EnvironmentObject var createTaskViewModel: CreateTaskViewModel
    @State var selectedDate: Date = Date()
    @State var showEditTaskView = false
    @State private var showUserSearchView: Bool = false
    @FocusState private var focusedRecommendedText: Bool
    @FocusState private var userSelected: Bool
    @State var isAddTaskInProgress = false
    
    init(accountId: String, suggestion: TaskSuggestionStruct, index: Int) {
        self.accountId = accountId
        self.suggestion = suggestion
        self.index = index
    }
    
    var body: some View {
        var suggestionId = suggestion.id
        let suggestedTaskState = createNoteScreenViewModel.suggestedTaskStates[suggestionId ?? ""] ?? [:]
        VStack {
            if suggestedTaskState["isTaskSaved"] as! Bool {
                SavedTaskCard(recommendedText: ((suggestedTaskState["description"] ?? "") as! String), selectedDate: selectedDate, assignedToUsername: (suggestedTaskState["assignedToUsername"] ?? "") as! String, index: index, accountId: accountId, taskId: (suggestedTaskState["taskId"] ?? "") as! String, onDeleteTask: {
                    createNoteScreenViewModel.removeTaskSuggestion(at: index)
                })
            } else {
                VStack {
                    // text editor component
                    HStack {
                        Text("\((suggestedTaskState["description"] ?? "") as! String)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("TextPrimary"))
                            .font(.nunitoSemiBold(size: 16))
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
                    HStack {
                        HStack {
                            Text("Assign to")
                                .foregroundColor(Color("TextPrimary"))
                                .font(.nunitoSemiBold(size: 12))
                                .tracking(0.5)
                            
                            // add verticle divider gray line
                            VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                            
                            Button(action: {
                                // Toggle user search view
                                showUserSearchView = true
                            }, label: {
                                if ((suggestedTaskState["assignedToUsername"] ?? "") as! String).isEmpty {
                                    Text("Select")
                                        .foregroundColor(Color("RedHighlight"))
                                        .font(.nunitoBold(size: 12))
                                        .tracking(0.5)
                                    
                                    Image(Asset.arrowDown.name)
                                        .frame(width: 6, height: 3)
                                        .padding(.trailing, 6)
                                } else {
                                    Text(BasicHelper.getInitials(from: ((suggestedTaskState["assignedToUsername"] ?? "") as! String)))
                                        .frame(width: 18, height: 18)
                                        .font(.nunitoBold(size: 6))
                                        .foregroundColor(Color.white)
                                        .background(Color("UserBubble"))
                                        .clipShape(RoundedRectangle(cornerRadius: 47))
                                        .accessibilityIdentifier("img_user_account_detail_user_initials_index_\(index)")
                                    
                                    Text(((suggestedTaskState["assignedToUsername"] ?? "") as! String))
                                        .foregroundColor(Color("RedHighlight"))
                                        .font(.nunitoBold(size: 12))
                                        .accessibilityIdentifier("txt_create_note_suggestion_user_index_\(index)")
                                        .tracking(0.5)
                                    
                                    Image(Asset.arrowDown.name)
                                        .frame(width: 6, height: 3)
                                        .padding(.trailing, 6)
                                }
                                
                            }
                                   )
                            .sheet(isPresented: $showUserSearchView) {
                                UserSearchView(isPresented: $showUserSearchView,
                                               onUserSelect: { userId, userName in
                                    createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "assignedToUsername", attrValue: userName)
                                    createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "selectedUserId", attrValue: userId)
                                })
                            }
                            .accessibilityIdentifier("btn_create_note_search_user_index_\(index)")
                            
                        }
                        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                        
                        Spacer()
                    }
                    
                    // due date component + picker
                    HStack {
                        HStack {
                            Text("Due")
                                .foregroundColor(Color("TextPrimary"))
                                .font(.nunitoSemiBold(size: 12))
                                .tracking(0.5)
                            
                            // add verticle divider gray line
                            VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                            
                            ZStack {
                                DatePickerView(selectedDate: $selectedDate, onTap: {
                                    createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "isDateSelected", attrValue: true)
                                })
                                .background(.white)
                                .cornerRadius(8)
                                .accessibilityIdentifier("dp_create_note_select_date_\(index)")
                                
                                if !(suggestedTaskState["isDateSelected"] as! Bool) {
                                    HStack(spacing: 0) {
                                        Text("Select Date")
                                            .foregroundColor(Color("TermsPrimary"))
                                            .font(.nunitoLight(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Image(Asset.emptyCalendar.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 6)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                    
                                } else {
                                    HStack(spacing: 0) {
                                        Text(BasicHelper.getDateStringFromDate(from: selectedDate))
                                            .foregroundColor(Color("TermsPrimary"))
                                            .font(.nunitoBold(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Image(Asset.emptyCalendar.name)
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
                    
                    // action buttons + view model
                    if !(suggestedTaskState["isTaskSaved"] as! Bool) {
                        HStack {
                            Button(action: {
                                isAddTaskInProgress = true
                                createTaskViewModel.createTask(accountId: accountId, assignedToName: ((suggestedTaskState["assignedToUsername"] ?? "") as! String), crmOrganizationUserId: ((suggestedTaskState["selectedUserId"] ?? "") as! String), description: ((suggestedTaskState["description"] ?? "") as! String), dueDate: selectedDate, onSuccess: { taskId in
                                    
                                    createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "taskId", attrValue: taskId)
                                    createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "isTaskSaved", attrValue: true)
                                    isAddTaskInProgress = false
                                }, onFailure: {
                                    isAddTaskInProgress = false
                                })
                            }, label: {
                                HStack(alignment: .center, spacing: 0) {
                                    if isAddTaskInProgress {
                                        ProgressView()
                                            .tint(Color("LoginButtonPrimary"))
                                            .controlSize(.small)
                                        Text("Adding Task...")
                                            .foregroundColor(.white)
                                            .font(.nunitoMedium(size: 12))
                                            .accessibilityIdentifier("txt_create_note_adding_task_index_\(index)")
                                        
                                    } else {
                                        Text("Add Task")
                                            .foregroundColor(.white)
                                            .font(.nunitoMedium(size: 12))
                                            .accessibilityIdentifier("txt_create_note_add_task_index_\(index)")
                                    }
                                }
                                .frame(width: isAddTaskInProgress ? 115 : 72, height: 32)
                                .background(
                                    Color(hex: "SaveButtonBackground")
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                            .disabled(accountId.isEmpty || ((suggestedTaskState["description"] ?? "") as! String).isEmpty || ((suggestedTaskState["selectedUserId"] ?? "") as! String).isEmpty || !(suggestedTaskState["isDateSelected"] as! Bool) || isAddTaskInProgress)
                            .opacity(accountId.isEmpty || ((suggestedTaskState["description"] ?? "") as! String).isEmpty || ((suggestedTaskState["selectedUserId"] ?? "") as! String).isEmpty || !(suggestedTaskState["isDateSelected"] as! Bool) ? 0.7 : 1)
                            .accessibilityIdentifier("btn_create_note_add_task_\(index)")
                            
                            Button(action: {
                                
                                AlertViewModel.shared.showAlert(_alert: Alert(
                                    title: "Remove Task Suggestion",
                                    message: Text("Are you sure you want to remove this task suggestion?"),
                                    submitText: "Remove",
                                    onSubmitPress: {
                                        createNoteScreenViewModel.removeTaskSuggestion(at: index)
                                    }
                                ))
                                
                            }, label: {
                                HStack(alignment: .center, spacing: 0) {
                                    Text("Cancel")
                                        .foregroundColor(Color("CancelText"))
                                        .font(.nunitoMedium(size: 12))
                                        .accessibilityIdentifier("txt_create_note_cancel_\(index)")
                                }
                                .frame(width: 72, height: 32)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                            .accessibilityIdentifier("btn_create_note_cancel_\(index)")
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("CancelText"), lineWidth: 1))
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1, 5])) // Specify the dash pattern here
                        .foregroundColor(Color("TextPrimary"))
                )
            }
        }
        .onChange(of: selectedDate, perform: {_ in
            createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "dueDate", attrValue: selectedDate)
        })
        .onAppear {
            self.selectedDate =  suggestedTaskState["dueDate"] as! Date
        }
        .onChange(of: createNoteScreenViewModel.suggestedData, perform: {_ in
            suggestionId = createNoteScreenViewModel.suggestedData.add_task_suggestions?[self.index].id
            let updatedTaskState = createNoteScreenViewModel.suggestedTaskStates[suggestionId ?? ""] ?? [:]
            self.selectedDate =  updatedTaskState["dueDate"] as! Date
            
        }
        )
        .background(
            NavigationLink(
                destination: CreateTaskScreen(accountId: accountId,
                                              suggestionId: suggestionId),
                isActive: self.$showEditTaskView
            ) {
                EmptyView()
            }
                .hidden()
        )
    }
    
}

struct SavedTaskCard: View {
    var recommendedText: String
    var selectedDate: Date
    var assignedToUsername: String = ""
    var index: Int
    var accountId: String
    var taskId: String
    var onDeleteTask: () -> Void
    @State var isPopoverVisible: Bool = false
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(BasicHelper.getInitials(from: UserStateViewModel.shared.currentUser.name))
                        .frame(width: 18, height: 18)
                        .font(.nunitoBold(size: 6))
                        .foregroundColor(Color.white)
                        .background(Color("UserBubble"))
                        .clipShape(RoundedRectangle(cornerRadius: 47))
                        .accessibilityIdentifier("img_creator_user_initials")
                    
                    Text(UserStateViewModel.shared.currentUser.name)
                        .foregroundColor(Color("TermsPrimary"))
                        .font(.nunitoMedium(size: 14))
                        .accessibilityIdentifier("txt_add_task_creator_user")
                        .tracking(0.5)
                    
                    Spacer()
                    Text("Just Now")
                        .foregroundColor(Color("TermsPrimary"))
                        .font(.nunitoLight(size: 12))
                        .accessibilityIdentifier("txt_created_timestamp")
                        .tracking(0.5)
                    
                    Button {
                        isPopoverVisible.toggle()
                    } label: {
                        Image(Asset.dotsThreeOutline.name)
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
                    .font(.nunitoSemiBold(size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("txt_create_note_task_description")
                    .padding(6)
                    .background(Color("AliceBlue"))
                    .cornerRadius(6)
                
                HStack {
                    HStack {
                        Text("Assign to")
                            .foregroundColor(Color("PortGore"))
                            .font(.nunitoSemiBold(size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("PortGore").opacity(0.5))
                        
                        Text(BasicHelper.getInitials(from: assignedToUsername))
                            .frame(width: 18, height: 18)
                            .font(.nunitoBold(size: 6))
                            .foregroundColor(Color.white)
                            .background(Color("UserBubble"))
                            .clipShape(RoundedRectangle(cornerRadius: 47))
                            .accessibilityIdentifier("img_user_account_detail_user_initials")
                        
                        Text(assignedToUsername)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.nunitoBold(size: 12))
                            .accessibilityIdentifier("txt_add_task_selected_user")
                            .tracking(0.5)
                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    .background(Color("GhostWhite"))
                    .cornerRadius(6)
                    
                    Spacer()
                }
                .padding(.vertical, 6)
                
                HStack {
                    HStack {
                        Text("Due")
                            .foregroundColor(Color("PortGore"))
                            .font(.nunitoSemiBold(size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("PortGore").opacity(0.5))
                        
                        Text(BasicHelper.getDateStringFromDate(from: selectedDate))
                            .foregroundColor(Color("PortGore"))
                            .font(.nunitoBold(size: 12))
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
            .overlay(alignment: .topTrailing) {
                if isPopoverVisible {
                    VStack {
                        Button(action: {
                            isPopoverVisible = false
                            
                            AlertViewModel.shared.showAlert(_alert: Alert(
                                title: "Delete Task",
                                message: Text("Are you sure you want to delete this task?"),
                                submitText: "Delete",
                                onSubmitPress: {
                                    acccountDetailScreenViewModelObject.deleteTask(accountId: accountId, taskId: taskId) {
                                        onDeleteTask()
                                    }
                                }
                            ))
                        }, label: {
                            HStack {
                                Image(Asset.deleteIcon.name)
                                    .frame(width: 20, height: 20)
                                Text("Delete")
                                    .font(.nunitoSemiBold(size: 16))
                                    .foregroundColor(Color("TextPrimary"))
                            }
                        }
                               )
                        .accessibilityIdentifier("btn_create_note_delete_task_\(index)")
                    }
                    .padding(10)
                    .cornerRadius(4)
                    .frame(width: 100, height: 40)
                    .background(Color("CardBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color("CardBorder"), lineWidth: 1)
                    )
                    .offset(x: -20, y: 42)
                }
            }
            .background(.white)
            
            HStack {
                Image(Asset.checkWithGreenTick.name)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Text("Task Added")
                    .foregroundColor(Color("PortGore"))
                    .font(.nunitoSemiBold(size: 12))
                    .accessibilityIdentifier("txt_create_note_task_added_\(index)")
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
        SavedTaskCard(recommendedText: "Hello text", selectedDate: Date(), assignedToUsername: "some user", index: 0, accountId: "sdfg34rf", taskId: "sdf234rtgv", onDeleteTask: {})
    }
}
