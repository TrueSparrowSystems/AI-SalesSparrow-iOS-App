//
//  TaskDetailScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 22/09/23.
//

import SwiftUI

struct TaskDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var taskDetailScreenViewModel : TaskDetailScreenViewModel
    
    var accountId: String
    var taskId: String
    var isEditFlow: Bool = false 
    @State var crm_organization_user_id: String = ""
    @State var crm_organization_user_name: String = ""
    @State var description: String = ""
    @State var selectedDate: Date = Date()
    @State var isDateSelected = false
    @State var isTaskSaved: Bool = false
    @FocusState private var focused: Bool
    @State private var showUserSearchView: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Text((isTaskSaved) ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier((isTaskSaved) ? "btn_add_task_done" : "btn_add_task_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    taskDetailScreenViewModel.EditTaskDetail(accountId: accountId, taskId: taskId, crm_organization_user_id: crm_organization_user_name, description: description, due_date: BasicHelper.getDateStringFromDate(from: selectedDate, dateFormat: "YYYY-MM-DD"), onSuccess: {
                        isTaskSaved = true
                    })
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(taskDetailScreenViewModel.isSaveTaskInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            
                            Text("Editing Task...")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_saving")
                        }else if(isTaskSaved){
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
                            Text("Edit Task")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_save")
                        }
                    }
                    .frame(width: taskDetailScreenViewModel.isSaveTaskInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_task")
                .disabled(accountId.isEmpty || taskId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || crm_organization_user_name.isEmpty || crm_organization_user_id.isEmpty || !isDateSelected)
                .opacity(calculateOpacity())
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
                    
                    Text(BasicHelper.getInitials(from: crm_organization_user_name))
                        .frame(width: 18, height: 18)
                        .font(.custom("Nunito-Bold", size: 6))
                        .foregroundColor(Color.white)
                        .background(Color("UserBubble"))
                        .clipShape(RoundedRectangle(cornerRadius: 47))
                    
                    Text(crm_organization_user_name)
                        .foregroundColor(Color("RedHighlight"))
                        .font(.custom("Nunito-Bold", size: 12))
                        .accessibilityIdentifier("txt_add_task_selected_user")
                    
                    Spacer()
                    
                    Image("ArrowDown")
                        .frame(width: 7, height: 4)
                        .opacity(isEditFlow ? 1 : 0)
                }
                .disabled(isEditFlow ? false : true)
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
                        crm_organization_user_id = userId
                        crm_organization_user_name = userName
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
                    DatePickerView(selectedDate: $selectedDate,onTap: {
                        isDateSelected = true
                    })
                    .disabled(isEditFlow ? false : true)
                    .background(.white)
                    .cornerRadius(8)
                    .accessibilityIdentifier("dp_add_task_select_date")
                    
                    
                    HStack (spacing: 0) {
                        Text(BasicHelper.getDateStringFromDate(from: selectedDate))
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
                if(taskDetailScreenViewModel.isFetchTaskInProgress){
                    Spacer()
                    ProgressView()
                        .accessibilityIdentifier("loader_note_detail")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .tint(Color("LoginButtonSecondary"))
                        .controlSize(.large)
                    Spacer()
                } else if(isEditFlow){
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
        .onAppear {
            // Adding a delay for view to render
            print(accountId)
            print(taskId)
            taskDetailScreenViewModel.fetchTaskDetail(accountId: accountId, taskId: taskId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
        .onChange(of: taskDetailScreenViewModel.currentTaskData){ currentTask  in
            print(currentTask)
            self.crm_organization_user_id = currentTask.crm_organization_user_id
            self.crm_organization_user_name = currentTask.crm_organization_user_name
            self.description = currentTask.description
            self.selectedDate = BasicHelper.getDateFromString(currentTask.due_date)
            isDateSelected = true
        }
        .onReceive(taskDetailScreenViewModel.$currentTaskData){ currentTask  in
            print(currentTask)
            self.crm_organization_user_id = currentTask.crm_organization_user_id
            self.crm_organization_user_name = currentTask.crm_organization_user_name
            self.description = currentTask.description
            self.selectedDate = BasicHelper.getDateFromString(currentTask.due_date)
            isDateSelected = true
        }
        .onTapGesture {
            focused = false
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
    
    func calculateOpacity() -> Double {
        if isEditFlow {
            if accountId.isEmpty || taskId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || crm_organization_user_name.isEmpty || crm_organization_user_id.isEmpty || !isDateSelected {
                return 0.7
            } else {
                return 1.0
            }
        } else {
            return 0.0
        }
    }
}


