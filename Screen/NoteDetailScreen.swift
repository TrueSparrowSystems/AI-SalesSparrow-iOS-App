//
//  NoteDetailScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 11/08/23.
//

import SwiftUI

struct NoteDetailScreen: View {
    @EnvironmentObject var noteDetailScreenViewModel: NoteDetailScreenViewModel
    @Environment(\.dismiss) private var dismiss
    
    var accountId: String
    var accountName: String
    var noteId: String
    var isEditFlow = false
    @State var isNoteSaved = false
    @State var parameterChanged = true
    @State var description: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(isEditFlow ? (isNoteSaved ? "Done" : "Cancel") : "Done")
                    .font(.nunitoBold( size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color(Asset.cancelText.name))
                    .accessibilityIdentifier((isNoteSaved) ? "btn_note_screen_done" : "btn_note_screen_cancel")
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                if isEditFlow {
                    Button(action: {
                        noteDetailScreenViewModel.editNoteDetail(text: description, accountId: accountId, noteId: noteId, onSuccess: {
                            isNoteSaved = true
                            dismiss()
                        })
                    }, label: {
                        HStack(alignment: .center, spacing: 0) {
                            if noteDetailScreenViewModel.isEditNoteInProgress {
                                ProgressView()
                                    .tint(Color(Asset.loginButtonPrimary.name))
                                    .controlSize(.small)
                                
                                Text("Saving...")
                                    .foregroundColor(.white)
                                    .font(.nunitoMedium( size: 12))
                                    .accessibilityIdentifier("txt_create_task_saving")
                            } else if isNoteSaved {
                                Image(Asset.checkMark.name)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .padding(.trailing, 6)
                                    .accessibilityIdentifier("img_create_task_checkmark")
                                
                                Text("Saved")
                                    .foregroundColor(.white)
                                    .font(.nunitoMedium( size: 12))
                                    .accessibilityIdentifier("txt_create_task_saved")
                            } else {
                                Image(Asset.salesforceIcon.name)
                                    .resizable()
                                    .frame(width: 17, height: 12)
                                    .padding(.trailing, 6)
                                    .accessibilityIdentifier("img_create_note_salesforce_icon")
                                
                                Text("Save")
                                    .foregroundColor(.white)
                                    .font(.nunitoMedium( size: 12))
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
                    .disabled((accountId.isEmpty || noteId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !parameterChanged) ? true : false)
                    .opacity(((accountId.isEmpty || noteId.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !parameterChanged) ? 0.7 : 1))
                }
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
                
                if isEditFlow {
                    TextField("Add Note", text: $description, axis: .vertical)
                        .foregroundColor(Color(Asset.textPrimary.name))
                        .font(.nunitoSemiBold( size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_edit_note")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                        }
                        .padding(.top)
                        .lineLimit(4...)
                } else {
                    Text(noteDetailScreenViewModel.noteDetail.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.nunitoSemiBold( size: 18))
                        .accessibilityIdentifier("txt_note_detail_text")
                        .foregroundColor(Color(Asset.textPrimary.name))
                    //                    HTMLTextView(htmlText: noteDetailScreenViewModel.noteDetail.text, textColor: UIColor(named: Asset.textPrimary.name) ?? .gray, font: UIFont(name: "Nunito-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18), backgroundColor: UIColor(named: "Background") ?? .white)
                    //                        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                    //                        .font(.nunitoSemiBold( size: 18))
                    //                        .accessibilityIdentifier("txt_note_detail_text")
                    //                        .foregroundColor(Color(Asset.textPrimary.name))
                    
                }
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(Color(Asset.background.name))
        .onAppear {
            noteDetailScreenViewModel.fetchNoteDetail(accountId: accountId, noteId: noteId)
        }
        .onChange(of: description) { newDescription  in
            if newDescription != noteDetailScreenViewModel.noteDetail.text {
                parameterChanged = true
                isNoteSaved = false
            } else {
                parameterChanged = false
                isNoteSaved = true
            }
        }
        .onReceive(noteDetailScreenViewModel.$noteDetail) { newCurrentNote in
            description = newCurrentNote.text
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focused = true
            }
        }
        .onTapGesture {
            focused = false
        }
    }
}
