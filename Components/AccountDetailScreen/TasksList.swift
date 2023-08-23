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
    
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @State private var showOverlay = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Image("TasksIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                    .accessibilityIdentifier("img_account_detail_task_icon")
                
                Text("Tasks")
                    .font(.custom("Nunito-SemiBold",size: 16))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_tasks_title")
                
                Spacer()
                
                //TODO: replace the navigation to create task once ready
                NavigationLink(destination: CreateNoteScreen(accountId: accountId, accountName: accountName, isAccountSelectable: false)
                ){
                    HStack{
                        Image("AddIcon")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .accessibilityIdentifier("img_account_detail_create_task_icon")
                    }
                    .frame(width: 40, height: 30, alignment: .bottomLeading)
                    .padding(.bottom, 10)
                    
                }
                .accessibilityIdentifier("btn_account_detail_add_task")
            }
            
            if acccountDetailScreenViewModelObject.isTaskLoading {
                ProgressView()
                    .tint(Color("LoginButtonSecondary"))
            }
            else if acccountDetailScreenViewModelObject.taskData.task_ids.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Add tasks, set due dates and assign to your team")
                            .font(.custom("Nunito-Regular",size: 12))
                            .foregroundColor(Color("TextPrimary"))
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                            .accessibilityIdentifier("txt_account_detail_add_task")
                        
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [2, 5], dashPhase: 10))
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
                VStack{
                    ForEach(self.acccountDetailScreenViewModelObject.taskData.task_ids, id: \.self){ id in
                        if self.acccountDetailScreenViewModelObject.taskData.task_map_by_id[id] != nil{
                            TaskCardView(taskId: id)
                        }
                        
                        
                    }
                }
                .padding(.trailing)
            }
        }.onAppear {
            acccountDetailScreenViewModelObject.fetchTasks(accountId: accountId)
        }
    }
}

struct TaskCardView: View {
    let taskId: String
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    var taskData: [String: Task] = [:]
    
    var body: some View {
        VStack(spacing: 5){
            HStack {
                Text("\(BasicHelper.getInitials(from: acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.creator_name ?? ""))")
                    .frame(width: 18, height:18)
                    .font(.custom("Nunito-Bold", size: 5.24))
                    .foregroundColor(.black)
                    .background(Color("UserBubble"))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .accessibilityIdentifier("txt_account_detail_task_creator_initials")
                
                Text("\(acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.creator_name ?? "")")
                    .font(.custom("Nunito-Medium",size: 14))
                    .tracking(0.6)
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_task_creator")
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("\(BasicHelper.getFormattedDateForCard(from: acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]!.last_modified_time))")
                }
                .font(.custom("Nunito-Light",size: 12))
                .tracking(0.5)
                .foregroundColor(Color("TextPrimary"))
                .accessibilityIdentifier("txt_account_detail_task_last_modified_time")
                
                Image("DotsThreeOutline")
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("img_account_detail_task_more_\(taskId)")
            }
            Text("\(acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.description ?? "")")
                .font(.custom("Nunito-Medium",size: 14))
                .foregroundColor(Color("TextPrimary"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("txt_account_detail_task_description")
                .padding(.top, 6)
            
            HStack(alignment: .center){
                Text("Assign to")
                    .font(.custom("Nunito-Regular",size: 12))
                    .foregroundColor(Color("TermsPrimary"))
                    .tracking(0.5)
                    .accessibilityIdentifier("txt_account_detail_task_assign_to_title")
                
                Text(acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]?.crm_organization_user_name ?? "")
                    .font(.custom("Nunito-Regular",size: 12))
                    .foregroundColor(Color("RedHighlight"))
                    .tracking(0.5)
                    .accessibilityIdentifier("txt_account_detail_task_assignee")
                
                Divider()
                    .frame(width: 0, height: 16)
                    .foregroundColor(Color("TermsPrimary").opacity(0.1))
                
                Image("CalendarCheck")
                    .frame(width: 16, height: 16)
                
                Text("Due \(BasicHelper.getFormattedDateForDueDate(from: acccountDetailScreenViewModelObject.taskData.task_map_by_id[taskId]!.due_date))")
                    .font(.custom("Nunito-Regular",size: 12))
                    .foregroundColor(Color("TermsPrimary"))
                    .tracking(0.5)
                    .accessibilityIdentifier("txt_account_detail_task_due_date")
                
                Spacer()
            }
            .padding(.top, 12)
            
        }
        .padding(14)
        .cornerRadius(5)
        .background(Color("CardBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("CardBorder"), lineWidth: 1)
        )
        
    }
}
