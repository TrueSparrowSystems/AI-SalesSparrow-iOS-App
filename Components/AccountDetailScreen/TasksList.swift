//
//  TasksList.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 22/08/23.
//

import SwiftUI

struct TasksList: View {
    let accountId: String
    let accountName: String
    
    @State var addTaskActivated = false
    @State var suggestionId: String = ""
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @Binding var propagateClick: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(Asset.tasksIcon.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                    .accessibilityIdentifier("img_account_detail_task_icon")
                
                Text("Tasks")
                    .font(.nunitoSemiBold(size: 16))
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .accessibilityIdentifier("txt_account_detail_tasks_title")
                
                Spacer()
                
                Button(action: {
                    suggestionId = UUID().uuidString
                    createNoteScreenViewModel.initTaskData(suggestion: TaskSuggestionStruct(id: suggestionId, description: ""))
                    addTaskActivated = true
                }, label: {
                    HStack {
                        Image(Asset.addIcon.name)
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .accessibilityIdentifier("img_account_detail_create_task_icon")
                    }
                    .frame(width: 40, height: 30, alignment: .bottomLeading)
                    .padding(.bottom, 10)
                    
                }
                )
                .accessibilityIdentifier("btn_account_detail_add_task")
            }
            
            if acccountDetailScreenViewModelObject.isTaskListLoading {
                ProgressView()
                    .tint(Color(Asset.loginButtonSecondary.name))
            } else if acccountDetailScreenViewModelObject.taskData.task_ids.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Add tasks, set due dates and assign to your team")
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                            .accessibilityIdentifier("txt_account_detail_add_task")
                        
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [2, 5], dashPhase: 10))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .background(
                                Color.clear
                                    .frame(height: 2)
                            )
                    )
                }
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                VStack {
                    let taskIdsArray = self.acccountDetailScreenViewModelObject.taskData.task_ids
                    ForEach(Array(taskIdsArray.enumerated()), id: \.offset) { index, taskId in
                        NavigationLink(destination: TaskDetailScreen(accountId: accountId, taskId: taskId, isEditFlow: false)
                        ) { if  self.acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId] != nil {
                            TaskCardView(taskId: taskId, accountId: accountId, taskIndex: index, propagateClick: $propagateClick)
                        }}
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("task_card_\(index)")
                    }
                }
                .padding(.trailing)
            }
        }.onAppear {
            acccountDetailScreenViewModelObject.fetchTasks(accountId: accountId)
        }
        .navigationDestination(isPresented: self.$addTaskActivated, destination: {
            CreateTaskScreen(accountId: accountId, suggestionId: suggestionId, isAccountDetailFlow: true)
        })
    }
}

struct TaskCardView: View {
    let taskId: String
    let accountId: String
    let taskIndex: Int
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    var taskData: [String: Task] = [:]
    @State var isPopoverVisible: Bool = false
    @Binding var propagateClick: Int
    @State var isSelfPopupTriggered = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(BasicHelper.getInitials(from: acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.creator_name ?? ""))")
                    .frame(width: 18, height: 18)
                    .font(.nunitoBold(size: 6))
                    .foregroundColor(.black)
                    .background(Color(Asset.userBubble.name))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .accessibilityIdentifier("txt_account_detail_task_creator_initials_\(taskIndex)")
                
                Text("\(acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.creator_name ?? "")")
                    .font(.nunitoMedium(size: 14))
                    .tracking(0.6)
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .accessibilityIdentifier("txt_account_detail_task_creator_\(taskIndex)")
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("\(BasicHelper.getFormattedDateForCard(from: acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.last_modified_time ?? ""))")
                        .font(.nunitoLight(size: 12))
                        .tracking(0.5)
                        .foregroundColor(Color(Asset.textPrimary.name))
                        .accessibilityIdentifier("txt_account_detail_task_last_modified_time_\(taskIndex)")
                    
                    Button {
                        isSelfPopupTriggered = true
                        isPopoverVisible.toggle()
                    } label: {
                        Image(Asset.dotsThreeOutline.name)
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .foregroundColor(Color(Asset.textPrimary.name))
                    }
                    .accessibilityIdentifier("btn_account_detail_task_more_\(taskIndex)")
                }
            }
            Text("\(acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.description ?? "")")
                .font(.nunitoMedium(size: 14))
                .foregroundColor(Color(Asset.textPrimary.name))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("txt_account_detail_task_description_\(taskIndex)")
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))
            
            HStack(alignment: .center) {
                Text("Assign to")
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(Color(Asset.termsPrimary.name))
                    .tracking(0.5)
                    .accessibilityIdentifier("txt_account_detail_task_assign_to_title_\(taskIndex)")
                
                Text(acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.crm_organization_user_name ?? "")
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(Color(Asset.redHighlight.name))
                    .tracking(0.5)
                    .accessibilityIdentifier("txt_account_detail_task_assignee_\(taskIndex)")
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                if acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.due_date != nil {
                    Divider()
                        .frame(width: 0, height: 16)
                        .foregroundColor(Color(Asset.termsPrimary.name).opacity(0.1))
                    
                    Image(Asset.calendarCheck.name)
                        .frame(width: 16, height: 16)
                    
                    Text("Due \(BasicHelper.getFormattedDateForDueDate(from: acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.due_date ?? ""))")
                        .font(.nunitoRegular(size: 12))
                        .foregroundColor(Color(Asset.termsPrimary.name))
                        .tracking(0.5)
                        .accessibilityIdentifier("txt_account_detail_task_due_date_\(taskIndex)")
                }
                
                Spacer()
            }
            .padding(.top, 12)
            
        }
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 15, trailing: 5))
        .cornerRadius(5)
        .background(Color(Asset.cardBackground.name))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            if isPopoverVisible {
                VStack(alignment: .leading) {
                    NavigationLink(destination: TaskDetailScreen(accountId: accountId, taskId: taskId, isEditFlow: true)
                    ) {
                        HStack {
                            Image(Asset.editIcon.name)
                                .frame(width: 20, height: 20)
                            Text("Edit")
                                .font(.nunitoSemiBold( size: 16))
                                .foregroundColor(Color(Asset.textPrimary.name))
                        }
                    }
                    .accessibilityIdentifier("btn_account_detail_edit_task_\(taskIndex)")
                    
                    Button(action: {
                        isPopoverVisible = false
                        AlertViewModel.shared.showAlert(_alert: Alert(
                            title: "Delete Task",
                            message: Text("Are you sure you want to delete this task?"),
                            submitText: "Delete",
                            onSubmitPress: {
                                acccountDetailScreenViewModelObject.deleteTask(accountId: accountId, taskId: taskId, onSuccess: {})
                            }
                        ))
                    }, label: {
                        HStack {
                            Image(Asset.deleteIcon.name)
                                .frame(width: 20, height: 20)
                            Text("Delete")
                                .font(.nunitoSemiBold(size: 16))
                                .foregroundColor(Color(Asset.textPrimary.name))
                        }
                    }
                    )
                    .accessibilityIdentifier("btn_account_detail_delete_task_\(taskIndex)")
                }
                .padding(10)
                .cornerRadius(4)
                .frame(width: 103, height: 88)
                .background(Color(Asset.cardBackground.name))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                )
                .offset(x: -14, y: 32)
            }
        }
        .onChange(of: propagateClick) {_ in
            // onChange to hide Popover for events triggered by other cards or screen
            
            if isSelfPopupTriggered {
                // Don't hide popover if event trigged by self
                isSelfPopupTriggered = false
            } else {
                isPopoverVisible = false
            }
        }
        
    }
}
