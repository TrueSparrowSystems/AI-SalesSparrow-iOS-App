//
//  SuggestedEventView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 21/09/23.
//

import SwiftUI

struct SuggestedEventCardView: View {
    var accountId: String
    var suggestion: EventSuggestionStruct
    var index: Int
    @Binding var propagateClick: Int
    
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    @EnvironmentObject var createEventViewModel: CreateEventViewModel
    @State var selectedStartDate: Date = Date()
    @State var selectedStartTime: Date = Date()
    @State var selectedEndDate: Date = Date()
    @State var selectedEndTime: Date = Date()
    @State var showEditEventView = false
    @State private var showUserSearchView: Bool = false
    @FocusState private var focusedRecommendedText: Bool
    @FocusState private var userSelected: Bool
    @State var isAddEventInProgress = false
    
    init(accountId: String, suggestion: EventSuggestionStruct, index: Int, propagateClick: Binding<Int>) {
        self.accountId = accountId
        self.suggestion = suggestion
        self.index = index
        self._propagateClick = propagateClick
    }
    
    var body: some View {
        var suggestionId = suggestion.id
        let suggestedEventState = createNoteScreenViewModel.suggestedEventStates[suggestionId ?? ""] ?? [:]
        VStack {
            if suggestedEventState["isEventSaved"] as! Bool {
                SavedEventCard(recommendedText: ((suggestedEventState["description"] ?? "") as! String), selectedStartDate: selectedStartDate, selectedStartTime: selectedStartTime, selectedEndDate: selectedEndDate, selectedEndTime: selectedEndTime, index: index, accountId: accountId, eventId: (suggestedEventState["eventId"] ?? "") as! String, onDeleteEvent: {
                    createNoteScreenViewModel.removeEventSuggestion(at: index)
                }, propagateClick: $propagateClick)
            } else {
                VStack {
                    // text editor component
                    HStack {
                        Text("\((suggestedEventState["description"] ?? "") as! String)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .font(.nunitoSemiBold(size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityIdentifier("txt_create_note_event_suggestion_title_\(index)")
                            .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                            .background(Color(Asset.ghostWhite.name).opacity(0.2))
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Do nothing. Kept on tap here to override tap action over parent tap action
                        showEditEventView = true
                    }
                    
                    VStack {
                        // start date component + picker
                        HStack {
                            Text("Start")
                                .frame(width: 30, height: 30, alignment: .leading)
                                .font(.nunitoBold(size: 12))
                                .foregroundColor(Color(Asset.textPrimary.name))
                                .accessibilityIdentifier("txt_add_events_start")
                            
                            ZStack {
                                if !(suggestedEventState["isEventSaved"] as! Bool) {
                                    DatePickerView(selectedDate: $selectedStartDate, onTap: {
                                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartDateSelected", attrValue: true)
                                    })
                                    .background(.white)
                                    .cornerRadius(8)
                                    .accessibilityIdentifier("dp_add_event_select_start_date")
                                }
                                
                                if !(suggestedEventState["isStartDateSelected"] as! Bool) {
                                    HStack(spacing: 0) {
                                        Text("Select Date")
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoLight(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.emptyCalendar.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 6)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                    
                                } else {
                                    HStack(spacing: 0) {
                                        Text(BasicHelper.getDateStringFromDate(from: selectedStartDate))
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoBold(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.emptyCalendar.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 10)
                                    }
                                    .accessibilityIdentifier("txt_add_event_select_start_date")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(width: 145, height: 30)
                            .clipped()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                            )
                            ZStack {
                                if !(suggestedEventState["isEventSaved"] as! Bool) {
                                    TimePickerView(selectedTime: $selectedStartTime, onTap: {
                                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isStartTimeSelected", attrValue: true)
                                    })
                                    .background(.white)
                                    .cornerRadius(8)
                                    .accessibilityIdentifier("dp_add_event_select_start_time")
                                }
                                
                                if !(suggestedEventState["isStartTimeSelected"] as! Bool) {
                                    HStack(spacing: 0) {
                                        Text("Select Time")
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoLight(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.clock.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 6)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                    
                                } else {
                                    HStack(spacing: 0) {
                                        Text(BasicHelper.getTimeStringFromDate(from: selectedStartTime))
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoBold(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.clock.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 10)
                                    }
                                    .accessibilityIdentifier("txt_add_event_select_start_time")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(width: 120, height: 30)
                            .clipped()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                            )
                            
                            Spacer()
                        }
                        
                        // end date component + picker
                        HStack {
                            Text("End")
                                .frame(width: 30, height: 30, alignment: .leading)
                                .font(.nunitoBold(size: 12))
                                .foregroundColor(Color(Asset.textPrimary.name))
                                .accessibilityIdentifier("txt_add_events_end")
                            
                            ZStack {
                                if !(suggestedEventState["isEventSaved"] as! Bool) {
                                    DatePickerView(selectedDate: $selectedEndDate, onTap: {
                                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndDateSelected", attrValue: true)
                                    })
                                    .background(.white)
                                    .cornerRadius(8)
                                    .accessibilityIdentifier("dp_add_event_select_end_date")
                                }
                                
                                if !(suggestedEventState["isEndDateSelected"] as! Bool) {
                                    HStack(spacing: 0) {
                                        Text("Select Date")
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoLight(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.emptyCalendar.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 6)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                    
                                } else {
                                    HStack(spacing: 0) {
                                        Text(BasicHelper.getDateStringFromDate(from: selectedEndDate))
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoBold(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.emptyCalendar.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 10)
                                    }
                                    .accessibilityIdentifier("txt_add_event_select_end_date")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(width: 145, height: 30)
                            .clipped()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                            )
                            
                            ZStack {
                                if !(suggestedEventState["isEventSaved"] as! Bool) {
                                    TimePickerView(selectedTime: $selectedEndTime, onTap: {
                                        createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEndTimeSelected", attrValue: true)
                                    })
                                    .background(.white)
                                    .cornerRadius(8)
                                    .accessibilityIdentifier("dp_add_event_select_end_time")
                                }
                                
                                if !(suggestedEventState["isEndTimeSelected"] as! Bool) {
                                    HStack(spacing: 0) {
                                        Text("Select Time")
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoLight(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.clock.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 6)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                    
                                } else {
                                    HStack(spacing: 0) {
                                        Text(BasicHelper.getTimeStringFromDate(from: selectedEndTime))
                                            .foregroundColor(Color(Asset.termsPrimary.name))
                                            .font(.nunitoBold(size: 12))
                                            .tracking(0.5)
                                            .padding(0)
                                        
                                        Spacer()
                                        
                                        Image(Asset.clock.name)
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 10)
                                    }
                                    .accessibilityIdentifier("txt_add_event_select_end_time")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.white)
                                    .userInteractionDisabled()
                                }
                            }
                            .padding(.horizontal, 10)
                            .frame(width: 120, height: 30)
                            .clipped()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                            )
                            Spacer()
                        }
                    }
                    .padding(8)
                    .cornerRadius(5)
                    .background(Color(Asset.aliceBlue.name))
                    .padding(.vertical, 10)
                    
                    // action buttons + view model
                    if !(suggestedEventState["isEventSaved"] as! Bool) {
                        HStack {
                            Button(action: {
                                isAddEventInProgress = true
                                createEventViewModel.createEvent(accountId: accountId, description: ((suggestedEventState["description"] ?? "") as! String), startDate: selectedStartDate, startTime: selectedStartTime, endDate: selectedEndDate, endTime: selectedEndTime, onSuccess: { eventId in
                                    createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "eventId", attrValue: eventId)
                                    createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "isEventSaved", attrValue: true)
                                    isAddEventInProgress = false
                                }, onFailure: {
                                    isAddEventInProgress = false
                                })
                            }, label: {
                                HStack(alignment: .center, spacing: 0) {
                                    if isAddEventInProgress {
                                        ProgressView()
                                            .tint(Color(Asset.loginButtonPrimary.name))
                                            .controlSize(.small)
                                            .padding(.trailing, 3)
                                        
                                        Text("Adding Event...")
                                            .foregroundColor(.white)
                                            .font(.nunitoMedium(size: 12))
                                            .accessibilityIdentifier("txt_create_note_adding_event_index_\(index)")
                                        
                                    } else {
                                        Text("Add Event")
                                            .foregroundColor(.white)
                                            .font(.nunitoMedium(size: 12))
                                            .accessibilityIdentifier("txt_create_note_add_event_index_\(index)")
                                    }
                                }
                                .frame(width: isAddEventInProgress ? 130 : 72, height: 32)
                                .background(
                                    Color(hex: "SaveButtonBackground")
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                            .disabled(accountId.isEmpty || ((suggestedEventState["description"] ?? "") as! String).isEmpty || !(suggestedEventState["isStartDateSelected"] as! Bool) || !(suggestedEventState["isStartTimeSelected"] as! Bool) || !(suggestedEventState["isEndDateSelected"] as! Bool) || !(suggestedEventState["isEndTimeSelected"] as! Bool) || isAddEventInProgress)
                            .opacity(accountId.isEmpty || ((suggestedEventState["description"] ?? "") as! String).isEmpty || !(suggestedEventState["isStartDateSelected"] as! Bool) || !(suggestedEventState["isStartTimeSelected"] as! Bool) || !(suggestedEventState["isEndDateSelected"] as! Bool) || !(suggestedEventState["isEndTimeSelected"] as! Bool) ? 0.7 : 1)
                            .accessibilityIdentifier("btn_create_note_add_event_\(index)")
                            
                            Button(action: {
                                
                                AlertViewModel.shared.showAlert(_alert: Alert(
                                    title: "Remove Event Suggestion",
                                    message: Text("Are you sure you want to remove this event suggestion?"),
                                    submitText: "Remove",
                                    onSubmitPress: {
                                        createNoteScreenViewModel.removeEventSuggestion(at: index)
                                    }
                                ))
                                
                            }, label: {
                                HStack(alignment: .center, spacing: 0) {
                                    Text("Cancel")
                                        .foregroundColor(Color(Asset.cancelText.name))
                                        .font(.nunitoMedium(size: 12))
                                        .accessibilityIdentifier("txt_create_note_cancel_\(index)")
                                }
                                .frame(width: 72, height: 32)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                            .accessibilityIdentifier("btn_create_note_event_cancel_\(index)")
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(Asset.cancelText.name), lineWidth: 1))
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1, 5])) // Specify the dash pattern here
                        .foregroundColor(Color(Asset.textPrimary.name))
                )
            }
        }
        .onChange(of: selectedStartDate, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "startDate", attrValue: selectedStartDate)
        })
        .onChange(of: selectedStartTime, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "startTime", attrValue: selectedStartTime)
        })
        .onChange(of: selectedEndDate, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "endDate", attrValue: selectedEndDate)
        })
        .onChange(of: selectedEndTime, perform: {_ in
            createNoteScreenViewModel.setEventDataAttribute(id: suggestionId ?? "", attrKey: "endTime", attrValue: selectedEndTime)
        })
        .onAppear {
            self.selectedStartDate =  suggestedEventState["startDate"] as! Date
            self.selectedStartTime =  suggestedEventState["startTime"] as! Date
            self.selectedEndDate =  suggestedEventState["endDate"] as! Date
            self.selectedEndTime =  suggestedEventState["endTime"] as! Date
        }
        .onChange(of: createNoteScreenViewModel.suggestedData, perform: {_ in
            suggestionId = createNoteScreenViewModel.suggestedData.add_event_suggestions?[self.index].id
            let updatedEventState = createNoteScreenViewModel.suggestedEventStates[suggestionId ?? ""] ?? [:]
            self.selectedStartDate =  updatedEventState["startDate"] as! Date
            self.selectedStartTime =  updatedEventState["startTime"] as! Date
            self.selectedEndDate =  updatedEventState["endDate"] as! Date
            self.selectedEndTime =  updatedEventState["endTime"] as! Date
            
        }
        )
        .navigationDestination(isPresented: self.$showEditEventView, destination: {
            CreateEventScreen(accountId: accountId, suggestionId: suggestionId)
        })
    }
    
}

struct SavedEventCard: View {
    var recommendedText: String
    var selectedStartDate: Date
    var selectedStartTime: Date
    var selectedEndDate: Date
    var selectedEndTime: Date
    var index: Int
    var accountId: String
    var eventId: String
    var onDeleteEvent: () -> Void
    @State var isPopoverVisible: Bool = false
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    @Binding var propagateClick: Int
    @State var isSelfPopupTriggered = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(BasicHelper.getInitials(from: UserStateViewModel.shared.currentUser.name))
                        .frame(width: 18, height: 18)
                        .font(.nunitoBold(size: 6))
                        .foregroundColor(Color.white)
                        .background(Color(Asset.userBubble.name))
                        .clipShape(RoundedRectangle(cornerRadius: 47))
                        .accessibilityIdentifier("img_creator_user_initials")
                    
                    Text(UserStateViewModel.shared.currentUser.name)
                        .foregroundColor(Color(Asset.termsPrimary.name))
                        .font(.nunitoMedium(size: 14))
                        .accessibilityIdentifier("txt_add_event_creator_user")
                        .tracking(0.5)
                    
                    Spacer()
                    Text("Just Now")
                        .foregroundColor(Color(Asset.termsPrimary.name))
                        .font(.nunitoLight(size: 12))
                        .accessibilityIdentifier("txt_created_timestamp")
                        .tracking(0.5)
                    
                    Button {
                        isSelfPopupTriggered = true
                        isPopoverVisible.toggle()
                    } label: {
                        Image(Asset.dotsThreeOutline.name)
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .foregroundColor(Color(Asset.textPrimary.name))
                    }
                    .accessibilityIdentifier("btn_create_note_event_more_\(index)")
                    
                }
                Text("\(recommendedText)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(Asset.portGore.name))
                    .font(.nunitoSemiBold(size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("txt_create_note_event_description")
                    .padding(6)
                    .background(Color(Asset.aliceBlue.name))
                    .cornerRadius(6)
                
                HStack {
                    HStack(alignment: .center, spacing: 0) {
                        Image(Asset.calendarCheck.name)
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 4)
                        
                        Text("From")
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color(Asset.termsPrimary.name))
                            .tracking(0.5)
                        
                        Divider()
                            .frame(width: 0, height: 16)
                            .foregroundColor(Color(Asset.termsPrimary.name).opacity(0.1))
                            .padding(.horizontal, 6)
                        
                        Text("\(BasicHelper.getFormattedDateForDateTime(from: BasicHelper.getFormattedDateTimeString(from: selectedStartDate, from: selectedStartTime)))")
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color(Asset.termsPrimary.name))
                            .tracking(0.5)
                            .accessibilityIdentifier("txt_create_note_event_start_date_\(index)")
                            .lineLimit(1)
                        
                        Text(" - \(BasicHelper.getFormattedDateForDateTime(from: BasicHelper.getFormattedDateTimeString(from: selectedEndDate, from: selectedEndTime)))")
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color(Asset.termsPrimary.name))
                            .tracking(0.5)
                            .accessibilityIdentifier("txt_create_note_event_end_date_\(index)")
                            .lineLimit(1)
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                }
            }
            .padding()
            .overlay(alignment: .topTrailing) {
                if isPopoverVisible {
                    VStack {
                        Button(action: {
                            isPopoverVisible = false
                            
                            AlertViewModel.shared.showAlert(_alert: Alert(
                                title: "Delete Event",
                                message: Text("Are you sure you want to delete this event?"),
                                submitText: "Delete",
                                onSubmitPress: {
                                    acccountDetailScreenViewModelObject.deleteEvent(accountId: accountId, eventId: eventId) {
                                        onDeleteEvent()
                                    }
                                }
                            ))
                        }, label: {
                            HStack {
                                Image(Asset.deleteIcon.name)
                                    .frame(width: 20, height: 20)
                                Text("Delete")
                                    .font(.nunitoSemiBold(size: 16))
                                    .foregroundColor(Color(Asset.textPrimary.name))
                            }
                        }
                        )
                        .accessibilityIdentifier("btn_create_note_delete_event_\(index)")
                    }
                    .padding(10)
                    .cornerRadius(4)
                    .frame(width: 100, height: 40)
                    .background(Color(Asset.cardBackground.name))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                    )
                    .offset(x: -20, y: 42)
                }
            }
            .background(.white)
            
            HStack {
                Image(Asset.checkWithGreenTick.name)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Text("Event Added")
                    .foregroundColor(Color(Asset.portGore.name))
                    .font(.nunitoSemiBold(size: 12))
                    .accessibilityIdentifier("txt_create_note_event_added_\(index)")
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(Asset.borderColor.name)), alignment: .top)
            .background(Color(Asset.pastelGreen.name).opacity(0.2))
        }
        .onChange(of: propagateClick) {_ in
            // onChange to hide Popover for events triggered by other cards or screen
            
            if isSelfPopupTriggered {
                // Don't hide popover if event trigged by self
                isSelfPopupTriggered = false
            } else {
                isPopoverVisible = false
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(Asset.borderColor.name), lineWidth: 1))
        
    }
}
