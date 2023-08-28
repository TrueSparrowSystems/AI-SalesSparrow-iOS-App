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
    
    @Binding var isPresented: Bool // This binding will control the presentation of the User search view sheet
    var accountId: String
    @Binding var description: String
    @Binding var dueDate: Date
    @Binding var crmOrganizationUserId: String
    @State var selectedUserName: String = ""
    @State var selectedUserId: String = ""
    @FocusState private var focused: Bool
    @State var isTaskSaved = false
    @State private var showUserSearchView: Bool = false
    
    var body: some View {
        ScrollView{
            HStack{
                Text("Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier("btn_add_task_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                
                Spacer()
                
                Button(action: {
                    createTaskViewModel.createTask(accountId: accountId, assignedToName: selectedUserName, crmOrganizationUserId: crmOrganizationUserId, description: description, dueDate: dueDate)
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(createTaskViewModel.isCreateTaskInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            Text("Adding Task...")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_saving")
                            
                        }else if(isTaskSaved){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_saved")
                        }else{
                            Text("Add Task")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_save")
                        }
                    }
                    .frame(width: createTaskViewModel.isCreateTaskInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_task")
                .disabled(disableSaveButton())
                .opacity(disableSaveButton() ? 0.7 : 1)
                .padding()
            }
        
            HStack {
                Text("Assign to")
                    .frame(width: 75,height: 30)
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
                    
                    Image("ArrowDown")
                        .frame(width: 7, height: 4)
                        .padding(.trailing, 6)
                }
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                .sheet(isPresented: $showUserSearchView){
                    UserSearchView(isPresented: $showUserSearchView,
                                   onUserSelect: { userId, userName in
                        selectedUserName = userId
                        selectedUserId = userName
                    })
                }
                
                Spacer()
            }
            .accessibilityIdentifier("btn_create_task_search_user")
            
            HStack {
                Text("Due")
                    .frame(width: 75,height: 30)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_tasks_due")
                
                Button(action:{
                    // TODO: Active picker flow
                }){
                    Text("Select")
                        .font(.custom("Nunito-Bold",size: 12))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_add_tasks_select")
                        .padding()
                    
                    Image("CalendarCheck")
                        .frame(width: 15, height: 15)
                        .padding(.leading, 10)
                }
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                
                Spacer()
            }
            
            Divider()
            
            TextField("Add Note",text: $description, axis: .vertical)
                .foregroundColor(Color("TextPrimary"))
                .font(.custom("Nunito-SemiBold", size: 18))
                .focused($focused)
                .accessibilityIdentifier("et_create_note")
                .onTapGesture {
                    // Do nothing. Kept on tap here to override tap action over parent tap action
                }
        }
        .padding()
    }
    
    private func disableSaveButton() -> Bool {
           return accountId.isEmpty || description.isEmpty || crmOrganizationUserId.isEmpty || selectedUserName.isEmpty
       }
}
