//
//  NoteDetailScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 11/08/23.
//

import SwiftUI

struct NoteDetailScreen : View {
    @EnvironmentObject var noteDetailScreenViewModel : NoteDetailScreenViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var accountId: String
    var accountName: String
    var noteId: String
    var isEditFlow = false
    @State var isNoteSaved = false
    @State var description: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text((isNoteSaved) ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier((isNoteSaved) ? "btn_add_note_done" : "btn_add_note_cancel")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                Button(action: {
                    noteDetailScreenViewModel.EditNoteDetail(text: description, accountId: accountId, noteId: noteId, onSuccess: {
                        isNoteSaved = true
                    })
                    }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(noteDetailScreenViewModel.isEditNoteInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            
                            Text("Editing Task...")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_saving")
                        }else if(isNoteSaved){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_task_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_saved")
                        }else{
                            Text("Add Note")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_task_save")
                        }
                    }
                    .frame(width: noteDetailScreenViewModel.isEditNoteInProgress ? 115 : 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_task")
                .disabled(shouldDisable())
                .opacity(calculateOpacity())
            }
            
            if(noteDetailScreenViewModel.isFetchNoteDetailInProgress){
                ProgressView()
                    .accessibilityIdentifier("loader_note_detail")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .tint(Color("LoginButtonSecondary"))
                    .controlSize(.large)
                
            }else if(noteDetailScreenViewModel.errorMessage != ""){
                Text(noteDetailScreenViewModel.errorMessage)
                    .foregroundColor(Color("TextPrimary"))
                    .accessibilityIdentifier("txt_note_detail_error")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            } else{
                HStack{
                    Image("AccountIcon")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .accessibilityIdentifier("img_note_detail_account_icon")
                    Text("Account")
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-Regular", size: 12))
                        .accessibilityIdentifier("txt_note_detail_account_text")
                    HStack(alignment: .center){
                        Text(accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 14))
                            .accessibilityIdentifier("txt_note_detail_account_name")
                    }
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    Spacer()
                }
                .padding(.top, 12)
                
                if isEditFlow {
                    TextField("Add Note",text: $description, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_create_task")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                        .padding(.top)
                        .lineLimit(4...)
                } else {
                    HTMLTextView(htmlText: noteDetailScreenViewModel.noteDetail.text, textColor: UIColor(named: "TextPrimary") ?? .gray, font: UIFont(name: "Nunito-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18), backgroundColor: UIColor(named: "Background") ?? .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .accessibilityIdentifier("txt_note_detail_text")
                        .foregroundColor(Color("TextPrimary"))
                }
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(Color("Background"))
        .onAppear{
            noteDetailScreenViewModel.fetchNoteDetail(accountId: accountId, noteId: noteId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
        .onChange(of: noteDetailScreenViewModel.noteDetail){ currentNote  in
            description = currentNote.text
        }
        .onChange(of: description) { newDescription  in
            if  newDescription != noteDetailScreenViewModel.noteDetail.text {
                isNoteSaved = false
            } else {
                isNoteSaved = true
            }
        }
        .onReceive(noteDetailScreenViewModel.$noteDetail) { newCurrentNote in
            description = newCurrentNote.text
        }
        .onTapGesture {
            focused = false
        }
    }
    
    func calculateOpacity() -> Double {
        if isEditFlow {
            if accountId.isEmpty || noteId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return 0.7
            } else {
                return 1.0
            }
        } else {
            return 0.0
        }
    }
    
    func shouldDisable() -> Bool {
        if (accountId.isEmpty || noteId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || noteDetailScreenViewModel.noteDetail.text == description){
            return true
        } else {
            return false
        }
    }
}
