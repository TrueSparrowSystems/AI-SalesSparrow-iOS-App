//
//  EventDetailScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 25/09/23.
//

import SwiftUI

struct EventDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var eventDetailScreenViewModel : EventDetailScreenViewModel
    
    var accountId: String
    var eventId: String
    var isEditFlow: Bool = false
    @State var description: String = ""
    @State var startDate: Date = Date()
    @State var startTime: Date = Date()
    @State var endDate: Date = Date()
    @State var endTime: Date = Date()
    @FocusState private var focused: Bool
    @State var isEventSaved: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Text((isEventSaved) ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier((isEventSaved) ? "btn_event_detail_done" : "btn_event_detail_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    eventDetailScreenViewModel.editEvent(accountId: accountId, description: description, startDate: startDate, startTime: startTime, endDate: endDate, endTime: endTime, onSuccess: {_ in 
                        isEventSaved = true
                        self.presentationMode.wrappedValue.dismiss()
                    }, onFailure: {})
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(eventDetailScreenViewModel.iseditEventInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            Text("Saving Event...")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_event_detail_saving")
                            
                        }else if(isEventSaved){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_event_detail_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_event_detail_saved")
                        }else{
                            Text("Save Event")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_event_detail_save")
                        }
                    }
                    .frame(width: eventDetailScreenViewModel.iseditEventInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_event")
                .disabled(calculateDisablity())
                .opacity(isEditFlow ? ((accountId.isEmpty || eventId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.7 : 1) : 0)
            }
            .padding(.vertical)
            
            if eventDetailScreenViewModel.isFetchEventInProgress {
                ProgressView()
                    .accessibilityIdentifier("loader_note_detail")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color("LoginButtonSecondary"))
                    .controlSize(.large)
            } else {
                HStack {
                    Text("Start")
                        .frame(width: 35,height: 30, alignment: .leading)
                        .font(.custom("Nunito-Regular",size: 14))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_event_detail_due")
                    
                    ZStack{
                        DatePickerView(selectedDate: $startDate, onTap: {
                            /*Set isDateSelected = true?*/
                        })
                            .disabled(isEditFlow ? false : true)
                            .background(.white)
                            .cornerRadius(8)
                            .accessibilityIdentifier("dp_event_detail_select_date")
                        
                        HStack (spacing: 0) {
                            Text(BasicHelper.getDateStringFromDate(from: startDate))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                                .accessibilityIdentifier("txt_event_detail_start_date")
                            
                            Spacer()
                            
                            Image("EmptyCalendar")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
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
                        TimePickerView(selectedTime: $startTime, onTap: {})
                        .disabled(isEditFlow ? false : true)
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_event_detail_select_time")

                        HStack (spacing: 0) {
                            Text(BasicHelper.getTimeStringFromDate(from: startTime))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                                .accessibilityIdentifier("txt_event_detail_start_time")
                            
                            Spacer()
                            
                            Image("Clock")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
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
                        .accessibilityIdentifier("txt_event_detail_due")
                    
                    ZStack{
                        DatePickerView(selectedDate: $endDate, onTap: {})
                        .disabled(isEditFlow ? false : true)
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_event_detail_select_date")
                        
                        HStack (spacing: 0) {
                            Text(BasicHelper.getDateStringFromDate(from: endDate))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                                .accessibilityIdentifier("txt_event_detail_end_date")
                            
                            Spacer()
                            
                            Image("EmptyCalendar")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
                        .accessibilityIdentifier("txt_event_detail_select_date")
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
                        TimePickerView(selectedTime: $endTime, onTap: {})
                        .disabled(isEditFlow ? false : true)
                        .background(.white)
                        .cornerRadius(8)
                        .accessibilityIdentifier("dp_event_detail_select_end_time")
                        
                        HStack (spacing: 0) {
                            Text(BasicHelper.getTimeStringFromDate(from: endTime))
                                .foregroundColor(Color("TermsPrimary"))
                                .font(.custom("Nunito-Bold", size: 12))
                                .tracking(0.5)
                                .padding(0)
                                .accessibilityIdentifier("txt_event_detail_end_time")
                            
                            Spacer()
                            
                            Image("Clock")
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                        }
                        .accessibilityIdentifier("txt_event_detail_select_time")
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
                    if(isEditFlow){
                        TextField("Add Event",text: $description, axis: .vertical)
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-SemiBold", size: 18))
                            .focused($focused)
                            .accessibilityIdentifier("et_edit_event")
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
        }
        .onChange(of: eventDetailScreenViewModel.currentEventData){ currentEvent in
            self.description = currentEvent.description
            self.startDate = BasicHelper.getDateFromString(currentEvent.start_datetime)
            self.startTime = BasicHelper.getDateFromString(currentEvent.start_datetime)
            self.endDate = BasicHelper.getDateFromString(currentEvent.end_datetime)
            self.endTime = BasicHelper.getDateFromString(currentEvent.end_datetime)
        }
        .onAppear {
            eventDetailScreenViewModel.fetchEventDetail(accountId: accountId, eventId: eventId, onSuccess: {_ in }, onFailure: {})
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
        .background(Color.white)
    }
    
    func calculateDisablity() -> Bool {
        return accountId.isEmpty || eventId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || eventDetailScreenViewModel.currentEventData.description == description || BasicHelper.getDateFromString(eventDetailScreenViewModel.currentEventData.start_datetime) == startDate || BasicHelper.getDateFromString(eventDetailScreenViewModel.currentEventData.end_datetime) == endDate || BasicHelper.getDateFromString(eventDetailScreenViewModel.currentEventData.start_datetime) == startTime || BasicHelper.getDateFromString(eventDetailScreenViewModel.currentEventData.end_datetime) == endTime
    }
}

