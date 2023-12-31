//
//  NoteList.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 10/08/23.
//

import SwiftUI

struct NotesList: View {
    let accountId: String
    let accountName: String
    
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    @State private var showOverlay = false
    @State var createNoteScreenActivated = false
    @Binding var propagateClick: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(Asset.noteIcon.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                    .accessibilityIdentifier("img_account_detail_note_icon")
                
                Text("Notes")
                    .font(.nunitoSemiBold(size: 16))
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .accessibilityIdentifier("txt_account_detail_notes_title")
                
                Spacer()
                
                NavigationLink(destination: CreateNoteScreen(accountId: accountId, accountName: accountName, isAccountSelectable: false)
                ) {
                    HStack {
                        Image(Asset.addIcon.name)
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .accessibilityIdentifier("img_account_detail_create_note_icon")
                    }
                    .frame(width: 40, height: 30, alignment: .bottomLeading)
                    .padding(.bottom, 10)
                    
                }
                .accessibilityIdentifier("btn_account_detail_add_note")
            }
            if acccountDetailScreenViewModelObject.isNoteListLoading {
                ProgressView()
                    .tint(Color(Asset.loginButtonSecondary.name))
            } else if acccountDetailScreenViewModelObject.noteData.note_ids.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Add notes and sync with your salesforce account")
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                            .accessibilityIdentifier("txt_account_detail_add_note_text")
                        
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [2, 5], dashPhase: 10))
                            .foregroundColor(Color(Asset.textPrimary.name))
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
                    let noteIdsArray = self.acccountDetailScreenViewModelObject.noteData.note_ids
                    ForEach(Array(noteIdsArray.enumerated()), id: \.offset) { index, noteId in
                        NavigationLink(destination: NoteDetailScreen(accountId: accountId, accountName: accountName, noteId: noteId, isEditFlow: false)
                        ) {
                            if self.acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId] != nil {
                                NoteCardView(noteId: noteId, accountId: accountId, accountName: accountName, noteIndex: index, propagateClick: $propagateClick)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("note_card_\(noteId)")
                    }
                }
                .padding(.trailing)
            }
        }.onAppear {
            acccountDetailScreenViewModelObject.fetchNotes(accountId: accountId)
        }
    }
    
}

struct NoteCardView: View {
    let noteId: String
    let accountId: String
    let accountName: String
    let noteIndex: Int
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    var noteData: [String: Note] = [:]
    @State var isPopoverVisible: Bool = false
    @Binding var propagateClick: Int
    @State var isSelfPopupTriggered = false
    @State private var isEditFlowActive = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(BasicHelper.getInitials(from: acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.creator ?? ""))")
                    .frame(width: 18, height: 18)
                    .font(.nunitoBold(size: 6))
                    .foregroundColor(.black)
                    .background(Color(Asset.userBubble.name))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .accessibilityIdentifier("txt_account_detail_note_creator_initials_\(noteIndex)")
                
                Text("\(acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.creator ?? "")")
                    .font(.nunitoMedium(size: 14))
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .accessibilityIdentifier("txt_account_detail_note_creator_\(noteIndex)")
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("\(BasicHelper.getFormattedDateForCard(from: acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.last_modified_time ?? ""))")
                        .font(.nunitoLight(size: 12))
                        .foregroundColor(Color(Asset.textPrimary.name))
                        .accessibilityIdentifier("txt_account_detail_note_last_modified_time_\(noteIndex)")
                    
                    Button {
                        isSelfPopupTriggered = true
                        isPopoverVisible.toggle()
                    } label: {
                        Image(Asset.dotsThreeOutline.name)
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .foregroundColor(Color(Asset.textPrimary.name))
                    }
                    .accessibilityIdentifier("btn_account_detail_edit_note_\(noteIndex)")
                }
            }
            Text("\(acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.text_preview ?? "")")
                .font(.nunitoMedium(size: 14))
                .foregroundColor(Color(Asset.textPrimary.name))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("txt_account_detail_note_text_\(noteIndex)")
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))
        }
        .frame(minHeight: 80)
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 15, trailing: 5))
        .cornerRadius(5)
        .background(Color(Asset.cardBackground.name))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
        )
        .navigationDestination(isPresented: self.$isEditFlowActive, destination: {
            NoteDetailScreen(accountId: accountId, accountName: accountName, noteId: noteId, isEditFlow: true, isNoteSaved: true)
        })
        .overlay(alignment: .topTrailing) {
            if isPopoverVisible {
                VStack {
                    Button(action: {
                        isEditFlowActive.toggle() // Toggle the state to activate/deactivate the link
                    }) {
                        HStack {
                            Image(Asset.editIcon.name)
                                .frame(width: 20, height: 20)
                            Text("Edit")
                                .font(.nunitoSemiBold( size: 16))
                                .foregroundColor(Color(Asset.textPrimary.name))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .accessibilityIdentifier("btn_account_detail_edit_\(noteIndex)")
                    
                    Button(action: {
                        isPopoverVisible = false
                        AlertViewModel.shared.showAlert(_alert: Alert(
                            title: "Delete Note",
                            message: Text("Are you sure you want to delete this note?"),
                            submitText: "Delete",
                            onSubmitPress: {
                                acccountDetailScreenViewModelObject.deleteNote(accountId: accountId, noteId: noteId)
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    )
                    .accessibilityIdentifier("btn_account_detail_delete_note_\(noteIndex)")
                }
                .padding(10)
                .cornerRadius(4)
                .frame(width: 103, height: 75)
                .background(Color(Asset.cardBackground.name))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                )
                .offset(x: -10, y: 35)
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
