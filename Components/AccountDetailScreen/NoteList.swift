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
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Image("NoteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20.0, height: 20.0)
                
                Text("Notes")
                    .font(.custom("Nunito-SemiBold",size: 16))
                    .foregroundColor(Color("TextPrimary"))
                
                Spacer()
                
                NavigationLink(destination: CreateNoteScreen(accountId: accountId, accountName: accountName, isAccountSelectable: false)
                ){
                    HStack{
                        Image("CreateNoteIcon")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                    }
                    .frame(width: 40, height: 30, alignment: .bottomLeading)
                    .padding(.bottom, 10)
                    
                }
            }
            if acccountDetailScreenViewModelObject.NotesData.note_ids.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Add notes and sync with your salesforce account")
                            .font(.custom("Nunito-Regular",size: 12))
                            .foregroundColor(Color("TextPrimary"))
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                        
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [1, 5], dashPhase: 10))
                            .background(
                                Color.clear
                                    .frame(height: 2)
                            )
                    )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                VStack{
                    ForEach(self.acccountDetailScreenViewModelObject.NotesData.note_ids, id: \.self){ id in
                        NavigationLink(destination: NoteDetailScreen(noteId: id, accountId: accountId, accountName: accountName)
                        ){
                            NoteCardView(NoteId: id)
                        }
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
    let NoteId: String
    @EnvironmentObject var acccountDetailScreenViewModelObject: AccountDetailViewScreenViewModel
    var NotesData: [String: Note] = [:]
    
    var body: some View {
        VStack(spacing: 5){
            HStack {
                Text("\(BasicHelper.getInitials(from: acccountDetailScreenViewModelObject.NotesData.note_map_by_id[NoteId]!.creator))")
                    .frame(width: 18.49, height:17.83)
                    .font(.custom("Nunito-Bold", size: 5.24))
                    .foregroundColor(.black)
                    .background(Color("UserBubble"))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                
                Text("\(acccountDetailScreenViewModelObject.NotesData.note_map_by_id[NoteId]!.creator)")
                    .font(.custom("Nunito-Medium",size: 14))
                    .foregroundColor(Color("TextPrimary"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("Tuesday")
                    Text(",")
                    Text("5:49pm")
                }
                .font(.custom("Nunito-Light",size: 12))
                .foregroundColor(Color("TextPrimary"))
                
                Image("DotsThreeOutline")
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color("TextPrimary"))
            }
            Text("\(acccountDetailScreenViewModelObject.NotesData.note_map_by_id[NoteId]!.text_preview)")
                .font(.custom("Nunito-Medium",size: 14))
                .foregroundColor(Color("TextPrimary"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .padding(14)
        .background(.white)
        .cornerRadius(5) /// make the background rounded
    }
}
