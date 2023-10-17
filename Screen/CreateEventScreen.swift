//
//  CreateEventScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 13/09/23.
//
import Foundation
import SwiftUI

struct CreateEventScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var createEventViewModel : CreateEventViewModel
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @EnvironmentObject var accountDetailViewModelObject : AccountDetailScreenViewModel
    
    var accountId: String
    @State var description: String = ""
    @State var startDate: Date = Date()
    @State var startTime: Date = Date()
    @State var endDate: Date = Date()
    @State var endTime: Date = Date()
    @FocusState private var focused: Bool
    @State var isAddEventInProgress = false
    var suggestionId: String?
    var isAccountDetailFlow: Bool = false
    
    var body: some View {
        let calendar = Calendar.current
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
                    createEventViewModel.createEvent(accountId: accountId, description: description, startDate: startDate, startTime: startTime, endDate:endDate, endTime: endTime, onSuccess: {eventId in
                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "eventId", attrValue: eventId)
                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEventSaved", attrValue: true)
                        isAddEventInProgress = false
                        if isAccountDetailFlow {
                            accountDetailViewModelObject.scrollToSection = "EventsList"
                        }
                        self.presentationMode.wrappedValue.dismiss()
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
                .disabled(accountId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !(suggestedEventState["isStartDateSelected"] as! Bool) || !(suggestedEventState["isStartTimeSelected"] as! Bool) || !(suggestedEventState["isEndDateSelected"] as! Bool) || !(suggestedEventState["isEndTimeSelected"] as! Bool) || isAddEventInProgress || (suggestedEventState["isEventSaved"] as! Bool))
                .opacity(accountId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !(suggestedEventState["isStartDateSelected"] as! Bool) || !(suggestedEventState["isStartTimeSelected"] as! Bool) || !(suggestedEventState["isEndDateSelected"] as! Bool) || !(suggestedEventState["isEndTimeSelected"] as! Bool) ? 0.7 : 1)
            }
            .padding(.vertical)
            
            
            HStack {
                Text("Start")
                    .frame(width: 35,height: 30, alignment: .leading)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_events_start")
                
                ZStack{
                    if(!(suggestedEventState["isEventSaved"] as! Bool)){
                        DatePickerView(selectedDate: $startDate, onTap: {
                            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartDateSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_event_select_start_date")
                    }
                    
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
                        .accessibilityIdentifier("txt_add_event_select_start_date")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                        .userInteractionDisabled()
                        
                }
                .padding(.horizontal, 10)
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                ZStack{
                    if(!(suggestedEventState["isEventSaved"] as! Bool)){
                        TimePickerView(selectedTime: $startTime, onTap: {
                            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartTimeSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_event_select_start_time")
                    }
                    

                        HStack (spacing: 0) {
                            Text(BasicHelper.getTimeStringFromDate(from: startTime))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                            
                            Spacer()
                            
                            Image("Clock")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
                        .accessibilityIdentifier("txt_add_event_select_start_time")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                        .userInteractionDisabled()
                        
                    
                }
                .padding(.horizontal, 10)
                .frame(width: 140, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                
                Spacer()
            }
            HStack {
                Text("End")
                    .frame(width: 35,height: 30, alignment: .leading)
                    .font(.custom("Nunito-Regular",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_add_events_end")
                
                ZStack{
                    if(!(suggestedEventState["isEventSaved"] as! Bool)){
                        DatePickerView(selectedDate: $endDate, onTap: {
                            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndDateSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_event_select_end_date")
                    }
                    
  
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
                        .accessibilityIdentifier("txt_add_event_select_end_date")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                        .userInteractionDisabled()
                        
             
                }
                .padding(.horizontal, 10)
                .frame(width: 160, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                
                
                ZStack{
                    if(!(suggestedEventState["isEventSaved"] as! Bool)){
                        TimePickerView(selectedTime: $endTime, onTap: {
                            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndTimeSelected", attrValue: true)
                        })
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_add_event_select_end_time")
                    }
                    

                        HStack (spacing: 0) {
                            Text(BasicHelper.getTimeStringFromDate(from: endTime))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                            
                            Spacer()
                            
                            Image("Clock")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
                        .accessibilityIdentifier("txt_add_event_select_end_time")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                        .userInteractionDisabled()
                        
                  
                }
                .padding(.horizontal, 10)
                .frame(width: 140, height: 30)
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
            endDate = startDate
        })
        .onChange(of: startTime, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "startTime", attrValue: startTime)
            if let oneHourLater = calendar.date(byAdding: .hour, value: 1, to: startTime) {
                endTime = oneHourLater
            }
        })
        .onChange(of: endDate, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "endDate", attrValue: endDate)
        })
        .onChange(of: endTime, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "endTime", attrValue: endTime)
        })
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
            self.description = ((suggestedEventState["description"] ?? "") as! String)
            
            self.startDate = (suggestedEventState["startDate"] ?? Date()) as! Date
            
            self.startTime = (suggestedEventState["startTime"] ?? Date()) as! Date
            
            self.endDate = (suggestedEventState["endDate"] ?? Date()) as! Date
            
            self.endTime = (suggestedEventState["endTime"] ?? Date()) as! Date
            
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartDateSelected", attrValue: true)
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartTimeSelected", attrValue: true)
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndDateSelected", attrValue: true)
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndTimeSelected", attrValue: true)
            if let oneHourLater = calendar.date(byAdding: .hour, value: 1, to: endTime) {
                endTime = oneHourLater
            }
        }
        .onTapGesture {
            focused = false
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
}
