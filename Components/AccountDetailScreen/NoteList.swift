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
            if showOverlay {
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        Text("Add notes and sync with your salesforce account")
                            .font(.custom("Nunito-Regular",size: 12))
                        Spacer()
                    }
                }
                .padding()
                .cornerRadius(5) /// make the background rounded
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 5)
                    //                    .stroke(Color("BorderColor"), lineWidth: 1)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1,5]))
                )
            } else {
                VStack{
                    ForEach(self.acccountDetailScreenViewModelObject.NotesData.note_ids, id: \.self){ id in
                        NavigationLink(destination: CreateNoteScreen(isAccountSelectable: true)
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
                Text("AB")
                    .frame(width: 22, height:22)
                    .font(.custom("Nunito-Bold", size: 7))
                    .foregroundColor(.black)
                    .background(Color(hex: "#C5B8FA"))
                    .clipShape(RoundedRectangle(cornerRadius: 11))
                
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
        }
        .padding(14)
        .background(.white)
        .cornerRadius(5) /// make the background rounded
    }
}
