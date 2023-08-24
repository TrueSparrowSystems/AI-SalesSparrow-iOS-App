//
//  CreateTaskScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 24/08/23.
//

import SwiftUI

struct CreateTaskScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var createTaskScreenViewModel : CreateTaskViewModel
    
    @Binding var isPresented: Bool // This binding will control the presentation of the sheet
    var accountId: String
    @Binding var description: String
    @Binding var dueDate: Date
    @Binding var crmOrganizationUserId: String
    @State var selectedUserName: String = ""
    @State var selectedUserId: String = ""
    @FocusState private var focused: Bool
    @State var isSaveInProgress = false
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
                
                Spacer()
                
                Button(action: {
                    isSaveInProgress = true
                    createTaskScreenViewModel.createTask(accountId: accountId, assignedToName: selectedUserName, crmOrganizationUserId: crmOrganizationUserId, description: description, dueDate: dueDate, onSuccess: {
                        isSaveInProgress = false
                        isTaskSaved = true
                    }, onFailure: {
                        isSaveInProgress = false
                    })
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(isSaveInProgress){
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
                    .frame(width: isSaveInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_task")
                .disabled(disableSaveButton())
                .opacity(disableSaveButton() ? 0.7 : 1)
            }
        
            HStack {
                Text("Assign to")
                
                Button(action:{
                    showUserSearchView = true
                }){
                    Text(BasicHelper.getInitials(from: selectedUserName))
                        .frame(width: 18, height: 18)
                        .font(.custom("Nunito-Bold", size: 6))
                        .foregroundColor(Color.white)
                        .background(Color("UserBubble"))
                        .clipShape(RoundedRectangle(cornerRadius: 47))
                        .accessibilityIdentifier("img_user_account_detail_user_initials")
                }
            }
            .sheet(isPresented: $showUserSearchView){
                UserSearchView(isPresented: $showUserSearchView,
                               onUserSelect: { userId, userName in
                    selectedUserName = userId
                    selectedUserId = userName
                })
            }
            .accessibilityIdentifier("btn_create_task_search_user")
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("CardBorder"), lineWidth: 1)
            )
            
            HStack {
                Text("Due")
                
                Button(action:{
                    showUserSearchView = true
                }){
                    Text("Select")
                        .padding()
                    
                    Image("CalenderCheck")
                        .frame(width: 15, height: 15)
                        .padding(.leading, 10)
                }
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                
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
    }
    
    private func disableSaveButton() -> Bool {
           return accountId.isEmpty || description.isEmpty || crmOrganizationUserId.isEmpty || selectedUserName.isEmpty
       }
}
