//
//  CreateEventScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 13/09/23.
//

import SwiftUI

struct CreateEventScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var createEventViewModel : CreateEventViewModel
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    
    var accountId: String
    @State var description: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @FocusState private var focused: Bool
    @State var isAddEventInProgress = false
    var suggestionId: String?
    
    var body: some View {
        let suggestedEventState = createNoteScreenViewModel.suggestedEventStates[suggestionId ?? ""] ?? [:]
        VStack{
            HStack{
                Text((suggestedEventState["isEventSaved"] as! Bool) ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier((suggestedEventState["isEventSaved"] as! Bool) ? "btn_add_event_done" : "btn_add_event_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    isAddEventInProgress = true
                    createEventViewModel.createEvent(accountId: accountId, description: description, startDate: startDate, endDate:endDate, onSuccess: {eventId in
                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "eventId", attrValue: eventId)
                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEventSaved", attrValue: true)
                        isAddEventInProgress = false
                    }, onFailure: {
                        isAddEventInProgress = false
                    })
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(isAddEventInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            Text("Adding Event...")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_event_saving")
                            
                        }else if((suggestedEventState["isEventSaved"] as! Bool)){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_event_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_event_saved")
                        }else{
                            Text("Add Event")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_event_save")
                        }
                    }
                    .frame(width: isAddEventInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_event")
                .disabled(accountId.isEmpty || description.isEmpty || !(suggestedEventState["isStartDateSelected"] as! Bool) || !(suggestedEventState["isEndDateSelected"] as! Bool) || isAddEventInProgress || (suggestedEventState["isEventSaved"] as! Bool))
                .opacity(accountId.isEmpty || description.isEmpty || !(suggestedEventState["isStartDateSelected"] as! Bool) || !(suggestedEventState["isEndDateSelected"] as! Bool) ? 0.7 : 1)
            }
            .padding(.vertical)
            
            
            HStack {
                Text("Start")
                    .frame(width: 75,height: 30, alignment: .leading)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_events_due")
                
                ZStack{
                    if(!(suggestedEventState["isEventSaved"] as! Bool)){
                        DatePickerView(selectedDate: $startDate, onTap: {
                            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartDateSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_event_select_date")
                    }
                    
                    if(!(suggestedEventState["isStartDateSelected"] as! Bool)){
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
                            Text(BasicHelper.getDateStringFromDate(from: startDate))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                            
                            Spacer()
                            
                            Image("EmptyCalendar")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
                        .accessibilityIdentifier("txt_add_event_select_date")
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
            HStack {
                Text("End")
                    .frame(width: 75,height: 30, alignment: .leading)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_events_due")
                
                ZStack{
                    if(!(suggestedEventState["isEventSaved"] as! Bool)){
                        DatePickerView(selectedDate: $endDate, onTap: {
                            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndDateSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_event_select_date")
                    }
                    
                    if(!(suggestedEventState["isEndDateSelected"] as! Bool)){
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
                            Text(BasicHelper.getDateStringFromDate(from: endDate))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                            
                            Spacer()
                            
                            Image("EmptyCalendar")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
                        .accessibilityIdentifier("txt_add_event_select_date")
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
            ScrollView{
                if(!(suggestedEventState["isEventSaved"] as! Bool)){
                    TextField("Add Event",text: $description, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_create_event")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                        .padding(.top)
                        .lineLimit(4...)
                }else{
                    Text(description)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .accessibilityIdentifier("txt_create_event_description")
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .onChange(of: description){_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "description", attrValue: self.description)
        }
        .onChange(of: startDate, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "startDate", attrValue: startDate)
        })
        .onChange(of: endDate, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "endDate", attrValue: endDate)
        })
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
            self.description = ((suggestedEventState["description"] ?? "") as! String)
            
            self.startDate = (suggestedEventState["startDate"] ?? Date()) as! Date
            
            self.endDate = (suggestedEventState["endDate"] ?? Date()) as! Date
            
        }
        .onTapGesture {
            focused = false
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
}
