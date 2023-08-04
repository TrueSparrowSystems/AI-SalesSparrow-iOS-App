//
//  CreateNoteScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import SwiftUI

struct CreateNoteScreen : View {
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    
    @State var text: String = ""
    @State var isSaveInProgress = false
    @State var isNoteSaved = false
    @State var accountId = ""
    @State var accountName = "SMagic"
    @State var showError = false
    @State var isAccountSelectable = true
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text(isNoteSaved ? "Done" : "Cancel")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color("CancelText"))
                    .accessibilityIdentifier("btn_cancel_create_note")
                Spacer()
                Button(action: {
                    isSaveInProgress = true
                    createNoteScreenViewModel.createNote(text: text,accountId: accountId, onSuccess: {
                        isSaveInProgress = false
                        isNoteSaved = true
                    }, onFailure: {
                        isSaveInProgress = false
                        showError = true
                    })
                }, label:{
                    HStack(alignment: .center, spacing: 0){
                        if(isSaveInProgress){
                            ProgressView()
                            Text("Saving")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                        }else if(isNoteSaved){
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                        }else{
                            Image("SalesforceIcon")
                                .resizable()
                                .frame(width: 17, height: 12)
                                .padding(.trailing, 6)
                            Text("Save")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 12))
                        }
                        
                    }
                    .frame(width: 68, height: 32)
                    .background(
                        Color(hex: "SaveButtonBackground")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .accessibilityIdentifier("btn_save_note")
                    .disabled(isNoteSaved)
                })
            }
            .padding(.vertical, 12)
            
            HStack{
                Image("AccountIcon")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("Account")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-Regular", size: 12))
                if(isAccountSelectable){
                    HStack(alignment: .center){
                        Text(accountId == "" ? "Select": accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Light", size: 14))
                        Image("ArrowDown")
                            .frame(width: 7, height: 4)
                            .padding(.trailing, 6)
                    }
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        //TODO: Update once Search Account is available
                        print("open search note")
                        accountName = "abc"
                        accountId = "12"
                    }
                    
                }else{
                    HStack(alignment: .center){
                        Text(accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color("RedHighlight"))
                            .font(.custom("Nunito-Bold", size: 14))
                    }
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                Spacer()
            }
            .padding(.top, 12)
            if text.isEmpty {
                VStack {
                    Text("Add Note")
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .opacity(0.6)
                    Spacer()
                }
            }
            
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 150)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
            .background(Color("Background"))
        Spacer()
    }
        .padding(.horizontal, 12)
}
}

struct CreateNoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteScreen()
    }
}
