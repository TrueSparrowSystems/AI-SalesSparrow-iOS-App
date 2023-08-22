//
//  AddButtonPopoverComponent.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 21/08/23.
//

import SwiftUI


struct AddButtonPopoverComponent: View{
    @Binding var isPopoverVisible : Bool
    var body: some View {
        
        VStack {
            HStack{
                Image("TasksIcon")
                Text("Add Tasks")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isPopoverVisible.toggle()
                print("Add Task")
            }
            HStack{
                Image("EventsIcon")
                Text("Add Event")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isPopoverVisible.toggle()
                print("Add Event")
            }
        }
        .padding(10)
        .background(Color("Background"))
        .border(Color(hex: "#DBDEEB"), width: 1)
        .frame(width: 200, height: 100)
        
    }
}
