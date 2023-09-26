//
//  EventsList.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 13/09/23.
//

import SwiftUI

struct EventsList: View {
    let accountId: String
    let accountName: String
    
    @State var addEventActivated = false
    @State var suggestionId: String = ""
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
    
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @Binding var propagateClick: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("EventsIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                    .accessibilityIdentifier("img_account_detail_event_icon")
                
                Text("Events")
                    .font(.nunitoSemiBold(size: 16))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_events_title")
                
                Spacer()
                
                Button(action: {
                    suggestionId = UUID().uuidString
                    createNoteScreenViewModel.initEventData(suggestion: EventSuggestionStruct(id: suggestionId, description: ""))
                    addEventActivated = true
                }
                ) {
                    HStack {
                        Image("AddIcon")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .accessibilityIdentifier("img_account_detail_create_event_icon")
                    }
                    .frame(width: 40, height: 30, alignment: .bottomLeading)
                    .padding(.bottom, 10)
                    
                }
                .accessibilityIdentifier("btn_account_detail_add_event")
            }
            
            if acccountDetailScreenViewModelObject.isEventListLoading {
                ProgressView()
                    .tint(Color("LoginButtonSecondary"))
            } else if acccountDetailScreenViewModelObject.eventData.event_ids.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Add events, set due dates and assign to your team")
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color("TextPrimary"))
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                            .accessibilityIdentifier("txt_account_detail_add_event")
                        
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [2, 5], dashPhase: 10))
                            .foregroundColor(Color("TextPrimary"))
                            .background(
                                Color.clear
                                    .frame(height: 2)
                            )
                    )
                }
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                VStack {
                    let eventIdsArray = self.acccountDetailScreenViewModelObject.eventData.event_ids
                    ForEach(Array(eventIdsArray.enumerated()), id: \.offset) { index, eventId in
                        if self.acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId] != nil {
                            EventCardView(eventId: eventId, accountId: accountId, eventIndex: index, propagateClick: $propagateClick)
                        }
                        
                    }
                }
                .padding(.trailing)
            }
        }.onAppear {
            acccountDetailScreenViewModelObject.fetchEvents(accountId: accountId)
        }.background {
            NavigationLink(destination:
                            CreateEventScreen(accountId: accountId, suggestionId: suggestionId),
                           isActive: self.$addEventActivated
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
}

struct EventCardView: View {
    let eventId: String
    let accountId: String
    let eventIndex: Int
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    var eventData: [String: Event] = [:]
    @State var isPopoverVisible: Bool = false
    @Binding var propagateClick: Int
    @State var isSelfPopupTriggered = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(BasicHelper.getInitials(from: acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.creator_name ?? ""))")
                    .frame(width: 18, height: 18)
                    .font(.nunitoBold(size: 6))
                    .foregroundColor(.black)
                    .background(Color("UserBubble"))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .accessibilityIdentifier("txt_account_detail_event_creator_initials_\(eventIndex)")
                
                Text("\(acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.creator_name ?? "")")
                    .font(.nunitoMedium(size: 14))
                    .tracking(0.6)
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_event_creator_\(eventIndex)")
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("\(BasicHelper.getFormattedDateForCard(from: acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.last_modified_time ?? ""))")
                        .font(.nunitoLight(size: 12))
                        .tracking(0.5)
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_account_detail_event_last_modified_time_\(eventIndex)")
                    
                    Button {
                        isSelfPopupTriggered = true
                        isPopoverVisible.toggle()
                    } label: {
                        Image("DotsThreeOutline")
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .foregroundColor(Color("TextPrimary"))
                    }
                    .accessibilityIdentifier("btn_account_detail_event_more_\(eventIndex)")
                }
            }
            Text("\(acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.description ?? "")")
                .font(.nunitoMedium(size: 14))
                .foregroundColor(Color("TextPrimary"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("txt_account_detail_event_description_\(eventIndex)")
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))
            
            HStack(alignment: .center, spacing: 0) {
                if acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.start_datetime != nil {
                    Image("CalendarCheck")
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 4)
                    
                    Text("From")
                        .font(.nunitoRegular(size: 12))                        .foregroundColor(Color("TermsPrimary"))
                        .tracking(0.5)
                    
                    Divider()
                        .frame(width: 0, height: 16)
                        .foregroundColor(Color("TermsPrimary").opacity(0.1))
                        .padding(.horizontal, 6)
                    
                    Text("\(BasicHelper.getFormattedDateForDateTime(from: acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.start_datetime ?? ""))")
                        .font(.nunitoRegular(size: 12))                        .foregroundColor(Color("TermsPrimary"))
                        .tracking(0.5)
                        .accessibilityIdentifier("txt_account_detail_event_start_date_\(eventIndex)")
                        .lineLimit(1)
                    
                    Text(" - \(BasicHelper.getFormattedDateForDateTime(from: acccountDetailScreenViewModelObject.eventData.event_map_by_id[eventId]?.end_datetime ?? ""))")
                        .font(.nunitoRegular(size: 12))
                        .foregroundColor(Color("TermsPrimary"))
                        .tracking(0.5)
                        .accessibilityIdentifier("txt_account_detail_event_end_date_\(eventIndex)")
                        .lineLimit(1)
                }
            }
            .padding(.top, 12)
            
        }
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 15, trailing: 5))
        .cornerRadius(5)
        .background(Color("CardBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("CardBorder"), lineWidth: 1)
        )
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
                                acccountDetailScreenViewModelObject.deleteEvent(accountId: accountId, eventId: eventId) {}
                            }
                        ))
                    }) {
                        HStack {
                            Image("DeleteIcon")
                                .frame(width: 20, height: 20)
                            Text("Delete")
                                .font(.nunitoSemiBold(size: 16))
                                .foregroundColor(Color("TextPrimary"))
                        }
                    }
                    .accessibilityIdentifier("btn_account_detail_delete_event_\(eventIndex)")
                }
                .padding(10)
                .cornerRadius(4)
                .frame(width: 100, height: 40)
                .background(Color("CardBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                .offset(x: -14, y: 32)
            }
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
        
    }
}
