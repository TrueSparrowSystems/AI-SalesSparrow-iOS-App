//
//  CreateTaskScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 24/08/23.
//

import SwiftUI

struct CreateTaskScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var createTaskViewModel : CreateTaskViewModel
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @EnvironmentObject var accountDetailViewModelObject : AccountDetailScreenViewModel
    
    var accountId: String
    @State var description: String = ""
    @State var dueDate: Date = Date()
    @FocusState private var focused: Bool
    @State private var showUserSearchView: Bool = false
    @State var isAddTaskInProgress = false
    var suggestionId: String?
    var isAccountDetailFlow: Bool = false
    
    var body: some View {
        let suggestedTaskState = createNoteScreenViewModel.suggestedTaskStates[suggestionId ?? ""] ?? [:]
        
        VStack{
            HStack{
                Text((suggestedTaskState["isTaskSaved"] as! Bool) ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier((suggestedTaskState["isTaskSaved"] as! Bool) ? "btn_add_task_done" : "btn_add_task_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    isAddTaskInProgress = true
                    createTaskViewModel.createTask(accountId: accountId, assignedToName: ((suggestedTaskState["assignedToUsername"] ?? "") as! String), crmOrganizationUserId: ((suggestedTaskState["selectedUserId"] ?? "") as! String), description: description, dueDate: dueDate, onSuccess: {taskId in
                        createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "taskId", attrValue: taskId)
                        createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "isTaskSaved", attrValue: true)
                        isAddTaskInProgress = false
                        if isAccountDetailFlow {
                            accountDetailViewModelObject.scrollToSection = "TasksList"
                        }
                        self.presentationMode.wrappedValue.dismiss()
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
                                .accessibilityIdentifier("txt_create_task_saving")
                            
                        }else if((suggestedTaskState["isTaskSaved"] as! Bool)){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_task_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_saved")
                        }else{
                            Text("Add Task")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_save")
                        }
                    }
                    .frame(width: isAddTaskInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_task")
                .disabled(accountId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || ((suggestedTaskState["selectedUserId"] ?? "") as! String).isEmpty || !(suggestedTaskState["isDateSelected"] as! Bool) || isAddTaskInProgress || (suggestedTaskState["isTaskSaved"] as! Bool))
                .opacity(accountId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || ((suggestedTaskState["selectedUserId"] ?? "") as! String).isEmpty || !(suggestedTaskState["isDateSelected"] as! Bool) ? 0.7 : 1)
            }
            .padding(.vertical)
            
            HStack {
                Text("Assign to")
                    .frame(width: 75,height: 30, alignment: .leading)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_tasks_assign_to")
                
                Button(action:{
                    showUserSearchView = true
                }){
                    if(((suggestedTaskState["assignedToUsername"] ?? "") as! String).isEmpty){
                        Text("Select")
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .accessibilityIdentifier("txt_add_task_selected_user")
                    } else{
                        Text(BasicHelper.getInitials(from: ((suggestedTaskState["assignedToUsername"] ?? "") as! String)))
                            .frame(width: 18, height: 18)
                            .font(.custom("Nunito-Bold", size: 6))
                            .foregroundColor(Color.white)
                            .background(Color("UserBubble"))
                            .clipShape(RoundedRectangle(cornerRadius: 47))
                            .accessibilityIdentifier("img_user_account_detail_user_initials")
                        
                        Text(((suggestedTaskState["assignedToUsername"] ?? "") as! String))
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .accessibilityIdentifier("txt_add_task_selected_user")
                    }
                    Spacer()
                    
                    Image("ArrowDown")
                        .frame(width: 7, height: 4)
                }
                .disabled((suggestedTaskState["isTaskSaved"] as! Bool))
                .accessibilityIdentifier("btn_create_task_search_user")
                .padding(.horizontal, 10)
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                .sheet(isPresented: $showUserSearchView){
                    UserSearchView(isPresented: $showUserSearchView,
                                   onUserSelect: { userId, userName in
                        createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "assignedToUsername", attrValue: userName)
                        createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "selectedUserId", attrValue: userId)
                    })
                }
                
                Spacer()
            }
            
            HStack {
                Text("Due")
                    .frame(width: 75,height: 30, alignment: .leading)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_tasks_due")
                
                ZStack{
                    if(!(suggestedTaskState["isTaskSaved"] as! Bool)){
                        DatePickerView(selectedDate: $dueDate, onTap: {
                            createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "isDateSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_task_select_date")
                    }
                    
                    HStack (spacing: 0) {
                        Text(BasicHelper.getDateStringFromDate(from: dueDate))
                            .foregroundColor(Color("TermsPrimary"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .tracking(0.5)
                            .padding(0)
                        
                        Spacer()
                        
                        Image("EmptyCalendar")
                            .frame(width: 15, height: 15)
                            .padding(.leading, 10)
                    }
                    .accessibilityIdentifier("txt_add_task_select_date")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
                    .userInteractionDisabled()
                    
                }
                .padding(.horizontal, 10)
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                
                Spacer()
            }
            ScrollView{
                if(!(suggestedTaskState["isTaskSaved"] as! Bool)){
                    TextField("Add Task",text: $description, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_create_task")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                        .padding(.top)
                        .lineLimit(4...)
                }else{
                    Text(description)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .accessibilityIdentifier("txt_create_task_description")
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .onChange(of: description){_ in
            createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "description", attrValue: self.description)
        }
        .onChange(of: dueDate, perform: {_ in
            createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "dueDate", attrValue: dueDate)
        })
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
            createNoteScreenViewModel.setTaskDataAttribute(id: suggestionId ?? "", attrKey: "isDateSelected", attrValue: true)
            self.description = ((suggestedTaskState["description"] ?? "") as! String)
            
            self.dueDate = (suggestedTaskState["dueDate"] ?? Date()) as! Date
            
        }
        .onTapGesture {
            focused = false
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
}
