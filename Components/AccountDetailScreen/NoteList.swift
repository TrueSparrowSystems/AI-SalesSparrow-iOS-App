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
    @Binding var propagateClick : Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Image("NoteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                    .accessibilityIdentifier("img_account_detail_note_icon")
                
                Text("Notes")
                    .font(.custom("Nunito-SemiBold",size: 16))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_notes_title")
                
                Spacer()
                
                NavigationLink(destination: CreateNoteScreen(accountId: accountId, accountName: accountName, isAccountSelectable: false)
                ){
                    HStack{
                        Image("AddIcon")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .accessibilityIdentifier("img_account_detail_create_note_icon")
                    }
                    .frame(width: 40, height: 30, alignment: .bottomLeading)
                    .padding(.bottom, 10)
                    
                }
                .accessibilityIdentifier("btn_account_detail_add_note")
            }
            if acccountDetailScreenViewModelObject.isNoteLoading {
                ProgressView()
                    .tint(Color("LoginButtonSecondary"))
            }
            else if acccountDetailScreenViewModelObject.noteData.note_ids.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Add notes and sync with your salesforce account")
                            .font(.custom("Nunito-Regular",size: 12))
                            .foregroundColor(Color("TextPrimary"))
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                            .accessibilityIdentifier("txt_account_detail_add_note_text")
                        
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [2, 5], dashPhase: 10))
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
                VStack{
                    let noteIdsArray = self.acccountDetailScreenViewModelObject.noteData.note_ids
                    ForEach(Array(noteIdsArray.enumerated()), id: \.offset) { index, noteId in
                        NavigationLink(destination: NoteDetailScreen(noteId: noteId, accountId: accountId, accountName: accountName)
                        ){
                            if self.acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId] != nil{
                                NoteCardView(noteId: noteId, accountId: accountId, accountName: accountName, noteIndex: index,propagateClick: $propagateClick)
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
    @Binding var propagateClick : Int
    @State var isSelfPopupTriggered = false
    @State var editNoteActivated = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Text("\(BasicHelper.getInitials(from: acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.creator ?? ""))")
                    .frame(width: 18, height:18)
                    .font(.custom("Nunito-Bold", size: 6))
                    .foregroundColor(.black)
                    .background(Color("UserBubble"))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .accessibilityIdentifier("txt_account_detail_note_creator_initials_\(noteIndex)")
                
                Text("\(acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.creator ?? "")")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_account_detail_note_creator_\(noteIndex)")
                
                Spacer()
                
                HStack(spacing: 0){
                    Text("\(BasicHelper.getFormattedDateForCard(from: acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.last_modified_time ?? ""))")
                        .font(.custom("Nunito-Light",size: 12))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_account_detail_note_last_modified_time_\(noteIndex)")
                    
                    
                    Button{
                        isSelfPopupTriggered = true
                        isPopoverVisible.toggle()
                    } label: {
                        Image("DotsThreeOutline")
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .foregroundColor(Color("TextPrimary"))
                    }
                    .accessibilityIdentifier("btn_account_detail_note_more_\(noteIndex)")
                }
            }
            Text("\(acccountDetailScreenViewModelObject.noteData.note_map_by_id[noteId]?.text_preview ?? "")")
                .font(.custom("Nunito-Medium",size: 14))
                .foregroundColor(Color("TextPrimary"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("txt_account_detail_note_text_\(noteIndex)")
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))
        }
        .padding(EdgeInsets(top: 5, leading: 15, bottom: 15, trailing: 5))
        .cornerRadius(5)
        .background(Color("CardBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("CardBorder"), lineWidth: 1)
        )
        .overlay(alignment: .topTrailing){
            if isPopoverVisible {
                VStack {
                    NavigationLink(destination: EditNoteScreen(accountId: accountId, noteId: noteId, accountName: accountName),
                                   isActive: self.$editNoteActivated
                    ){
                        HStack{
                            Image("EditIcon")
                                .frame(width: 20, height: 20)
                            Text("Edit")
                                .font(.custom("Nunito-SemiBold",size: 16))
                                .foregroundColor(Color("TextPrimary"))
                            
                            Spacer()
                        }
                        .onTapGesture {
                            isPopoverVisible = false
                            editNoteActivated = true
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("btn_account_detail_edit_note_\(noteIndex)")
                    
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
                    }){
                        HStack{
                            Image("DeleteIcon")
                                .frame(width: 20, height: 20)
                            Text("Delete")
                                .font(.custom("Nunito-SemiBold",size: 16))
                                .foregroundColor(Color("TextPrimary"))
                            
                            Spacer()
                        }
                    }
                    .accessibilityIdentifier("btn_account_detail_delete_note_\(noteIndex)")
                    
                    
                }
                .padding(10)
                .cornerRadius(4)
                .frame(width: 100, height: 70)
                .background(Color("CardBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("CardBorder"), lineWidth: 1)
                )
                .offset(x: -14, y: 32)
//                .background{
//                    NavigationLink(destination:
//                                    CreateEventScreen(accountId: accountId, suggestionId: suggestionId),
//                                   isActive: self.$addEventActivated
//                    ) {
//                        EmptyView()
//                    }
//                    .hidden()
//                }
            }
        }
        .onChange(of: propagateClick){_ in
            // onChange to hide Popover for events triggered by other cards or screen
            
            if(isSelfPopupTriggered){
                // Don't hide popover if event trigged by self
                isSelfPopupTriggered = false
            }else{
                isPopoverVisible = false
            }
        }
    }
}
