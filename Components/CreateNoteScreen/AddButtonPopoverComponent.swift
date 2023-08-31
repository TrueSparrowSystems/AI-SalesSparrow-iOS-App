//
//  AddButtonPopoverComponent.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 21/08/23.
//

import SwiftUI


struct AddButtonPopoverComponent: View{
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    
    @Binding var isPopoverVisible : Bool
    var accountId: String
    
    @State var addTaskActivated = false
    @State var suggestionId: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                suggestionId = UUID().uuidString
                createNoteScreenViewModel.initTaskData(suggestion: SuggestionStruct(id: suggestionId, description: ""))
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
                            CreateTaskScreen(accountId: accountId, suggestionId: suggestionId),
                           isActive: self.$addTaskActivated
            ) {
                EmptyView()
            }
            .hidden()
        }
        
    }
}
