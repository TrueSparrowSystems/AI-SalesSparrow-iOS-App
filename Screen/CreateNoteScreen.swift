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
    @State var accountName = "SMagic"
    @State var showError = false
    @State var isAccountSelectable = true
    @State var showAccountSearchView = false
    @State private var toast: Toast? = nil
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
                        ToastViewModel.shared.showToast(_toast: Toast(style: .success, message: "Note is saved to your Salesforce Account"))
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
                })
                .accessibilityIdentifier("btn_save_note")
                .disabled(isNoteSaved || isSaveInProgress || accountId == "" || text == "")
            }
            .padding(.vertical, 12)
            
            HStack{
                Image("AccountIcon")
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text("Account")
                    .foregroundColor(Color("TextPrimary"))
                    .font(.custom("Nunito-Regular", size: 12))
                if(isAccountSelectable && !(isNoteSaved || isSaveInProgress)){
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("Nunito-SemiBold", size: 18))
                    
                }else{
                    TextField("Add Note",text: $text, axis: .vertical)
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .focused($focused)
                }
            }
            Spacer()
            
        }
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
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
