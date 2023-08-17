//
//  CreateNoteScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import SwiftUI

struct CreateNoteScreen : View {
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var text: String = ""
    @State var isSaveInProgress = false
    @State var isNoteSaved = false
    @State var accountId = ""
    @State var accountName = ""
    @State var isAccountSelectable = true
    @State var showAccountSearchView = false
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text(isNoteSaved ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier(isNoteSaved ? "btn_done_create_note" : "btn_cancel_create_note")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    isSaveInProgress = true
                    createNoteScreenViewModel.createNote(text: text,accountId: accountId, onSuccess: {
                        isSaveInProgress = false
                        isNoteSaved = true
                    }, onFailure: {
                        isSaveInProgress = false
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
                .disabled(isNoteSaved || isSaveInProgress || accountId == "" || text == "")
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
                if(isAccountSelectable && !(isNoteSaved || isSaveInProgress)){
                    HStack(alignment: .center){
                        Text(accountId == "" ? "Select": accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Light", size: 14))
                            .accessibilityIdentifier(accountId == "" ? "txt_create_note_select_account" : "txt_create_note_selected_account")
                        Image("ArrowDown")
                            .frame(width: 7, height: 4)
                            .padding(.trailing, 6)
                    }
                    .accessibilityIdentifier("btn_select_account")
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        showAccountSearchView = true
                    }
                    .sheet(isPresented: $showAccountSearchView, onDismiss: {
                    }) {
                        AccountSearchView(isPresented: $showAccountSearchView, isCreateNoteFlow: true, onNoteCreateSelected: { _accountId, _accountName in
                            accountId = _accountId
                            accountName = _accountName
                        })
                    }
                    
                }else{
                    HStack(alignment: .center){
                        Text(accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 14))
                            .accessibilityIdentifier("cn_selected_account")
                    }
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                Spacer()
            }
            .padding(.top, 12)
            
            HStack{
                if(isNoteSaved || isSaveInProgress){
                    Text(text)
                        .foregroundColor(Color("TextPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Nunito-SemiBold", size: 18))
                    
                }else{
                    TextField("Add Note",text: $text, axis: .vertical)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                        .accessibilityIdentifier("et_create_note")
                }
            }
            Spacer()
            
        }
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(Color("Background"))
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
        }
    }
}

struct CreateNoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteScreen()
    }
}
