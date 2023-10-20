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
    @State var addEventActivated = false
    @State var suggestionId: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                suggestionId = UUID().uuidString
                createNoteScreenViewModel.initTaskData(suggestion: TaskSuggestionStruct(id: suggestionId, description: ""))
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
            
            Button(action: {
                suggestionId = UUID().uuidString
                createNoteScreenViewModel.initEventData(suggestion: EventSuggestionStruct(id: suggestionId, description: ""))
                addEventActivated = true
            }, label: {
                HStack{
                    Image("EventsIcon")
                    Text("Add Event")
                        .font(.custom("Nunito-SemiBold",size: 16))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_create_note_popover_add_event")
                }
            })
            .accessibilityIdentifier("btn_create_note_popover_add_event")
            .contentShape(Rectangle())
        }
        .padding(10)
        .cornerRadius(4)
        .background(Color("CardBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color("CardBorder"), lineWidth: 1)
        )
        .frame(width: 200, height: 100)
        .navigationDestination(isPresented: self.$addTaskActivated, destination: {
            CreateTaskScreen(accountId: accountId, suggestionId: suggestionId)
        })
        .navigationDestination(isPresented: self.$addEventActivated, destination: {
            CreateEventScreen(accountId: accountId, suggestionId: suggestionId)
        })
    }
}
