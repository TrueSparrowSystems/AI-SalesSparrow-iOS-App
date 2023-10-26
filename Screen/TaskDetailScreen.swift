//
//  TaskDetailScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 22/09/23.
//

import SwiftUI

struct TaskDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskDetailScreenViewModel: TaskDetailScreenViewModel
    
    var accountId: String
    var taskId: String
    var isEditFlow: Bool = false 
    @State var crm_organization_user_id: String = ""
    @State var crm_organization_user_name: String = ""
    @State var description: String = ""
    @State var selectedDate: Date = Date()
    @State var isTaskSaved: Bool = false
    @State var parameterChanged: Bool = false
    @State private var isInitialState = true
    @FocusState private var focused: Bool
    @State private var showUserSearchView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text(isEditFlow ? (isTaskSaved ? "Done" : "Cancel") : "Done")
                        .font(.custom("Nunito-Bold", size: 14))
                        .padding(.vertical, 10)
                        .foregroundColor(Color(Asset.cancelText.name))
                })
                .accessibilityIdentifier(isTaskSaved ? "btn_add_task_done" : "btn_add_task_cancel")
                
                Spacer()
                
                Button(action: {
                    taskDetailScreenViewModel.EditTaskDetail(accountId: accountId, taskId: taskId, crm_organization_user_id: crm_organization_user_id, description: description, due_date: BasicHelper.formatDate(selectedDate), onSuccess: {
                        isTaskSaved = true
                        dismiss()
                    })
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        if taskDetailScreenViewModel.isSaveTaskInProgress {
                            ProgressView()
                                .tint(Color(Asset.loginButtonPrimary.name))
                                .controlSize(.small)
                            
                            Text("Saving...")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_saving")
                        } else if isTaskSaved {
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_task_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_saved")
                        } else {
                            Image("SalesforceIcon")
                                .resizable()
                                .frame(width: 17, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_salesforce_icon")
                            
                            Text("Save")
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
                .disabled((accountId.isEmpty || taskId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || crm_organization_user_name.isEmpty || crm_organization_user_id.isEmpty || !parameterChanged) ? true : false)
                .opacity((isEditFlow) ? ((accountId.isEmpty || taskId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || crm_organization_user_name.isEmpty || crm_organization_user_id.isEmpty || !parameterChanged) ? 0.7 : 1) : 0)
            }
            .padding(.vertical)
            
            if taskDetailScreenViewModel.isFetchTaskInProgress {
                Spacer()
                ProgressView()
                    .accessibilityIdentifier("loader_note_detail")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color(Asset.loginButtonSecondary.name))
                    .controlSize(.large)
                Spacer()
            } else {
                HStack {
                    Text("Assign to")
                        .frame(width: 75, height: 30, alignment: .leading) 
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(Color(Asset.textPrimary.name))
                        .accessibilityIdentifier("txt_add_tasks_assign_to")
                    
                    Button(action: {
                        showUserSearchView = true
                    }) {
                        
                        Text(BasicHelper.getInitials(from: crm_organization_user_name))
                            .frame(width: 18, height: 18)
                            .font(.custom("Nunito-Bold", size: 6))
                            .foregroundColor(Color.white)
                            .background(Color(Asset.userBubble.name))
                            .clipShape(RoundedRectangle(cornerRadius: 47))
                        
                        Text(crm_organization_user_name)
                            .foregroundColor(Color(Asset.redHighlight.name))
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
                            .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                    )
                    .sheet(isPresented: $showUserSearchView) {
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
                        .frame(width: 75, height: 30, alignment: .leading)
                        .font(.custom("Nunito-Regular", size: 14))
                        .foregroundColor(Color(Asset.textPrimary.name))
                        .accessibilityIdentifier("txt_add_tasks_due")
                    
                    ZStack {
                        DatePickerView(selectedDate: $selectedDate, onTap: {})
                            .disabled(isEditFlow ? false : true)
                            .background(.white)
                            .cornerRadius(8)
                            .accessibilityIdentifier("dp_add_task_select_date")
                            .compositingGroup()
                            .scaleEffect(x: 1.5, y: 1.5)
                            .clipped()
                        
                        HStack(spacing: 0) {
                            Text(BasicHelper.getDateStringFromDate(from: selectedDate))
                                .foregroundColor(Color(Asset.termsPrimary.name))
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
                            .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                    )
                    
                    Spacer()
                }
                ScrollView {
                    if isEditFlow {
                        TextField("Add Task", text: $description, axis: .vertical)
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .font(.custom("Nunito-SemiBold", size: 18))
                            .focused($focused)
                            .accessibilityIdentifier("et_create_task")
                            .onTapGesture {
                                // Do nothing. Kept on tap here to override tap action over parent tap action
                            }
                            .padding(.top)
                            .lineLimit(4...)
                    } else {
                        Text(description)
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .font(.custom("Nunito-SemiBold", size: 18))
                            .accessibilityIdentifier("txt_create_task_description")
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .onAppear {
            taskDetailScreenViewModel.fetchTaskDetail(accountId: accountId, taskId: taskId, onFailure: {
                dismiss()
            })
        }
        .onReceive(taskDetailScreenViewModel.$currentTaskData) { currentTask  in
            isTaskSaved = true
            self.crm_organization_user_id = currentTask.crm_organization_user_id
            self.crm_organization_user_name = currentTask.crm_organization_user_name
            self.description = currentTask.description
            self.selectedDate = BasicHelper.getDateFromString(currentTask.due_date)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focused = true
                isInitialState = false
            }
        }
        .onChange(of: description) { _  in
            if isParameterAltered() {
                parameterChanged = true
                isTaskSaved = false
            } else if areParameterSame() {
                parameterChanged = false
                isTaskSaved = true
            }
        }
        .onChange(of: selectedDate) { _  in
            if isParameterAltered() {
                parameterChanged = true
                isTaskSaved = false
            } else if areParameterSame() {
                parameterChanged = false
                isTaskSaved = true
            }
        }
        .onChange(of: crm_organization_user_id) { _  in
            if isParameterAltered() {
                parameterChanged = true
                isTaskSaved = false
            } else if areParameterSame() {
                parameterChanged = false
                isTaskSaved = true
            }
        }
        .onTapGesture {
            focused = false
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
    
    func isParameterAltered() -> Bool {
        description != taskDetailScreenViewModel.currentTaskData.description || selectedDate != BasicHelper.getDateFromString( taskDetailScreenViewModel.currentTaskData.due_date) || crm_organization_user_id != taskDetailScreenViewModel.currentTaskData.crm_organization_user_id
    }
    
    func areParameterSame() -> Bool {
        description == taskDetailScreenViewModel.currentTaskData.description || selectedDate == BasicHelper.getDateFromString( taskDetailScreenViewModel.currentTaskData.due_date) || crm_organization_user_id == taskDetailScreenViewModel.currentTaskData.crm_organization_user_id
    }
}
