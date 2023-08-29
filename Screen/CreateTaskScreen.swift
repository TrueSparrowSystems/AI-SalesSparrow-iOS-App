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
    
    var accountId: String
    @Binding var description: String
    @Binding var dueDate: Date
    @Binding var crmOrganizationUserId: String
    @Binding var isDateSelected: Bool
    @Binding var selectedUserName: String
    @Binding var isTaskSaved: Bool
    @Binding var taskId: String
    @FocusState private var focused: Bool
    @State private var showUserSearchView: Bool = false
    
    var body: some View {
        ScrollView{
            HStack{
                Text(isTaskSaved ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier(isTaskSaved ? "btn_add_task_done" : "btn_add_task_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    createTaskViewModel.createTask(accountId: accountId, assignedToName: selectedUserName, crmOrganizationUserId: crmOrganizationUserId, description: description, dueDate: dueDate){taskId in
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
                            Text("Add Task")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_save")
                        }
                    }
                    .frame(width: createTaskViewModel.isCreateTaskInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_task")
                .disabled(accountId.isEmpty || description.isEmpty || crmOrganizationUserId.isEmpty || !isDateSelected || createTaskViewModel.isCreateTaskInProgress || isTaskSaved)
                .opacity(accountId.isEmpty || description.isEmpty || crmOrganizationUserId.isEmpty || !isDateSelected ? 0.7 : 1)
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
                    if(selectedUserName.isEmpty){
                        Text("Select")
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .accessibilityIdentifier("txt_add_task_selected_user")
                    } else{
                        Text(BasicHelper.getInitials(from: selectedUserName))
                            .frame(width: 18, height: 18)
                            .font(.custom("Nunito-Bold", size: 6))
                            .foregroundColor(Color.white)
                            .background(Color("UserBubble"))
                            .clipShape(RoundedRectangle(cornerRadius: 47))
                            .accessibilityIdentifier("img_user_account_detail_user_initials")
                        
                        Text(selectedUserName)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 12))
                            .accessibilityIdentifier("txt_add_task_selected_user")
                    }
                    Spacer()
                    
                    Image("ArrowDown")
                        .frame(width: 7, height: 4)
                }
                .disabled(isTaskSaved)
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
                        selectedUserName = userName
                        crmOrganizationUserId = userId
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
                    if(!isTaskSaved){
                        DatePickerView(selectedDate: $dueDate, onTap: {
                            isDateSelected = true
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_task_select_date")
                    }
                    
                    if(!isDateSelected){
                        HStack (spacing: 0) {
                            Text("Select")
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Light", size: 12))
                                .tracking(0.5)
                                .padding(0)
                            
                            Spacer()
                            
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                        .userInteractionDisabled()
                    }
                }
                .padding(.horizontal, 10)
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                
                Spacer()
            }
            
            if(!isTaskSaved){
                TextField("Add Task",text: $description, axis: .vertical)
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-SemiBold", size: 18))
                    .focused($focused)
                    .accessibilityIdentifier("et_create_task")
                    .onTapGesture {
                        // Do nothing. Kept on tap here to override tap action over parent tap action
                    }
                    .padding(.top)
            }else{
                Text(description)
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-SemiBold", size: 18))
                    .accessibilityIdentifier("txt_create_task_description")
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
        .onTapGesture {
            focused = false
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
    }
}
