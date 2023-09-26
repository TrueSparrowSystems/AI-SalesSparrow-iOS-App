//
//  NoteDetailScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 11/08/23.
//

import SwiftUI

struct NoteDetailScreen: View {
    @EnvironmentObject var noteDetailScreenViewModel: NoteDetailScreenViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var noteId: String = ""
    @State var accountId = ""
    @State var accountName = ""
    @State var isEditing = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Done")
                    .font(.nunitoBold(size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color(Asset.cancelText.name))
                    .accessibilityIdentifier("btn_done_note_screen")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                // TODO: uncomment this code once edit functionality is implemented
                //                if(isEditing){
                //                    HStack(alignment: .center, spacing: 0){
                //                        Image(Asset.checkMark.name)
                //                            .resizable()
                //                            .frame(width: 12, height: 12)
                //                            .padding(.trailing, 6)
                //                        Text("Saved")
                //                            .foregroundColor(.white)
                //                            .font(.nunitoMedium(size: 12))
                //                    }
                //                    .frame(width: 68, height: 32)
                //                    .background(
                //                        Color(hex: "SaveButtonBackground")
                //                    )
                //                    .clipShape(RoundedRectangle(cornerRadius: 5))
                //                    .accessibilityIdentifier("btn_note_saved")
                //                }
            }
            
            if noteDetailScreenViewModel.isFetchNoteDetailInProgress {
                ProgressView()
                    .accessibilityIdentifier("loader_note_detail")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color(Asset.loginButtonSecondary.name))
                    .controlSize(.large)
                
            } else if !noteDetailScreenViewModel.errorMessage.isEmpty {
                Text(noteDetailScreenViewModel.errorMessage)
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .accessibilityIdentifier("txt_note_detail_error")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            } else {
                HStack {
                    Image(Asset.accountIcon.name)
                        .resizable()
                        .frame(width: 14, height: 14)
                        .accessibilityIdentifier("img_note_detail_account_icon")
                    Text("Account")
                        .foregroundColor(Color(Asset.textPrimary.name))
                        .font(.nunitoRegular(size: 12))
                        .accessibilityIdentifier("txt_note_detail_account_text")
                    HStack(alignment: .center) {
                        Text(accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color(Asset.redHighlight.name))
                            .font(.nunitoBold(size: 14))
                            .accessibilityIdentifier("txt_note_detail_account_name")
                    }
                    .background(Color(Asset.selectAccountDropdownBG.name))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    Spacer()
                }
                .padding(.top, 12)
                
                HTMLTextView(htmlText: noteDetailScreenViewModel.noteDetail.text, textColor: UIColor(named: "TextPrimary") ?? .gray, font: UIFont(name: "Nunito-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18), backgroundColor: UIColor(named: "Background") ?? .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.nunitoSemiBold(size: 18))
                    .accessibilityIdentifier("txt_note_detail_text")
                    .foregroundColor(Color(Asset.textPrimary.name))
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(Color(Asset.background.name))
        .onAppear {
            noteDetailScreenViewModel.fetchNoteDetail(accountId: accountId, noteId: noteId)
        }
    }
}

struct NoteDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailScreen()
    }
}
