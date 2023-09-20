//
//  EditNoteScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 20/09/23.
//

import SwiftUI

struct EditNoteScreen : View {
    @EnvironmentObject var noteDetailScreenViewModel : NoteDetailScreenViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var accountId: String
    @State var noteId: String
    @State var accountName: String
    @State var currentNote: NoteDetailStruct = NoteDetailStruct(id: "", creator: "", text: "", last_modified_time: "")
    @State var initalText: String = ""
    @State var isSaveInProgress = false
    @State var isNoteSaved = true
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text("Done")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier("btn_done_edit_note")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    isSaveInProgress = true
                    noteDetailScreenViewModel.EditNoteDetail(text: currentNote.text, accountId: accountId, noteId: noteId,onSuccess: {
                        currentNote.text = initalText
                    })
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(isSaveInProgress){
                            ProgressView()
                                .tint(Color("LoginButtonPrimary"))
                                .controlSize(.small)
                            Text("Saving")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_saving")
                            
                        }else if(isNoteSaved){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_saved")
                        }else{
                            Image("SalesforceIcon")
                                .resizable()
                                .frame(width: 17, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_salesforce_icon")
                            
                            Text("Save")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                                .accessibilityIdentifier("txt_create_note_save")
                        }
                    }
                    .frame(width: 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                })
                .accessibilityIdentifier("btn_save_note")
                .disabled(isNoteSaved || isSaveInProgress || accountId.isEmpty || currentNote.text.isEmpty)
                .opacity(accountId.isEmpty || currentNote.text.isEmpty ? 0.7 : 1)
            }
            .padding(.vertical, 12)
            
            HStack{
                Image("AccountIcon")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .accessibilityIdentifier("img_create_note_account_icon")
                
                Text("Account")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-Regular", size: 12))
                    .accessibilityIdentifier("txt_create_note_account")
                
                HStack(alignment: .center){
                    Text(accountName)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 6)
                        .foregroundColor(Color("RedHighlight"))
                        .font(.custom("Nunito-Bold", size: 14))
                        .accessibilityIdentifier("txt_create_note_selected_account")
                }
                .background(Color("SelectAccountDropdownBG"))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.top, 12)
            
            ScrollView{
                HStack{
                    TextField("Add Note",text: $currentNote.text, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_create_note")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                        .lineLimit(4...)
                        
                }
                .contentShape(Rectangle())
            }
            .scrollIndicators(.hidden)
            .gesture(DragGesture().onChanged{_ in
            })
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(.white)
        .onAppear {
            noteDetailScreenViewModel.fetchNoteDetail(accountId: accountId, noteId: noteId)
            currentNote = noteDetailScreenViewModel.noteDetail
            initalText = currentNote.text
            print(initalText)
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
        .onChange(of: currentNote.text) { newText  in
            if  newText != initalText {
                isNoteSaved = false
            } else {
                isNoteSaved = true
            }
        }
        .onDisappear {
            // Perform cleanup/reset actions when the view is dismissed
            currentNote = NoteDetailStruct(id: "", creator: "", text: "", last_modified_time: "")
            isSaveInProgress = false
            isNoteSaved = true
        }

    }
}
