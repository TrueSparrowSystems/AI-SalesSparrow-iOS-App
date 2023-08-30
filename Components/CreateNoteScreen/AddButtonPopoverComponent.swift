//
//  AddButtonPopoverComponent.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 21/08/23.
//

import SwiftUI


struct AddButtonPopoverComponent: View{
    @Binding var isPopoverVisible : Bool
    var accountId: String
    @State var addTaskActivated = false
    
    @State var recommendedText: String = ""
    @State var selectedDate: Date = Date()
    @State var selectedUserId: String = ""
    @State var selectedUserName: String = ""
    @State var taskId: String = ""
    @State var isDateSelected = false
    @State var isTaskSaved = false
    
    var body: some View {
        VStack {
            Button(action: {
                addTaskActivated = true
            }, label: {
                HStack{
                    Image("TasksIcon")
                    Text("Add Tasks")
                        .font(.custom("Nunito-SemiBold",size: 16))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_create_note_popover_add_task")
                }
            })
            .accessibilityIdentifier("btn_create_note_popover_add_task")
            .contentShape(Rectangle())
            // TODO: Uncomment once we add create event flow
            //            HStack{
            //                Image("EventsIcon")
            //                Text("Add Event")
            //            }
            //            .contentShape(Rectangle())
            //            .onTapGesture {
            //                isPopoverVisible.toggle()
            //                print("Add Event")
            //            }
        }
        .padding(10)
        .cornerRadius(4)
        .background(Color("CardBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("CardBorder"), lineWidth: 1)
        )
        .frame(width: 200, height: 50)
        .background{
            NavigationLink(destination:
                            CreateTaskScreen(accountId: accountId,
                                             description: $recommendedText,
                                             dueDate: $selectedDate,
                                             crmOrganizationUserId: $selectedUserId,
                                             isDateSelected: $isDateSelected,
                                             selectedUserName: $selectedUserName, 
                                             isTaskSaved: $isTaskSaved, 
                                             taskId: $taskId),
                           isActive: self.$addTaskActivated
            ) {
                EmptyView()
            }
            .hidden()
        }
        
    }
}
