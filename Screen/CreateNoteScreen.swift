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
    @State var isPopoverVisible = false
    @FocusState private var focused: Bool
    @State var cancelSuggestedTask: Bool = false
    
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
                .disabled(isNoteSaved || isSaveInProgress || accountId.isEmpty || text.isEmpty)
                .opacity(accountId.isEmpty || text.isEmpty ? 0.7 : 1)
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
                    .accessibilityIdentifier("txt_create_note_select_account")
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
                            .accessibilityIdentifier("txt_create_note_selected_account")
                    }
                    .background(Color("SelectAccountDropdownBG"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.top, 12)
            ScrollView{
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
                            .onTapGesture {
                                // Do nothing. Kept on tap here to override tap action over parent tap action
                            }
                        
                    }
                }
                .contentShape(Rectangle())
                
                if(isNoteSaved){
                    VStack{
                        if(createNoteScreenViewModel.isSuggestionGenerationInProgress){
                            HStack{
                                Image("Sparkle")
                                Text("Getting recommendations")
                                    .foregroundColor(Color("TextPrimary"))
                                    .font(.custom("Nunito-SemiBold", size: 16))
                                Spacer()
                            }
                            
                            VStack(spacing: 0) {
                                ProgressView()
                                    .tint(Color("BrinkPink"))
                                    .controlSize(.large)
                                
                                Text("Please wait, we're checking to recommend tasks or events for you.")
                                    .foregroundColor(Color("TermsPrimary"))
                                    .font(.custom("Nunito-SemiBold" ,size: 14))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                            }
                            .padding(.vertical,16)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1,5]))
                                    .foregroundColor(Color("TextPrimary"))
                            )
                        }
                        else if(createNoteScreenViewModel.suggestedTaskData.add_task_suggestions.count == 0){ // check for count of suggested task array
                            // Show no recommendation message
                            VStack(spacing: 0) {
                                Image("Check")
                                    .frame(width: 28, height: 28, alignment: .center)
                                
                                Text("You are all set, no recommendation for now!")
                                    .foregroundColor(Color("TermsPrimary"))
                                    .font(.custom("Nunito-SemiBold" ,size: 14))
                                    .frame(alignment: .center)
                                    .padding(.top, 16)
                            }
                            .padding(.vertical,16)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1,5]))
                                    .foregroundColor(Color("TextPrimary"))
                            )
                        } else {
                            HStack{
                                Image("Sparkle")
                                Text("We have some recommendations")
                                    .foregroundColor(Color("TextPrimary"))
                                    .font(.custom("Nunito-SemiBold", size: 16))
                                    .accessibilityIdentifier("txt_create_note_recommendations")
                                
                                Spacer()
                                Button{
                                    isPopoverVisible.toggle()
                                } label: {
                                    Image("AddIcon")
                                        .frame(width: 20, height: 20)
                                }
                                
                            }
                            let addTaskSuggestions = createNoteScreenViewModel.suggestedTaskData.add_task_suggestions
                            ForEach(Array(addTaskSuggestions.enumerated()), id: \.offset) { index, suggestion in
                                SuggestedTaskCardView(accountId: accountId, suggestion:xw suggestion,index: index)
                            }
                        }
                        
                    }
                    .overlay(alignment: .topTrailing){
                        if isPopoverVisible {
                            AddButtonPopoverComponent(isPopoverVisible: $isPopoverVisible, accountId: accountId)
                                .offset(x: 35,y: 25)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .gesture(DragGesture().onChanged{_ in
                if(isPopoverVisible){
                    isPopoverVisible.toggle()
                }else{
                    focused = false
                }
            })
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 12)
        .navigationBarBackButtonHidden(true)
        .background(.white)
        .onAppear {
            // Adding a delay for view to render
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                focused = true
            }
            isPopoverVisible = false
        }
        .onTapGesture {
            if(isPopoverVisible){
                isPopoverVisible.toggle()
            }else{
                focused = false
            }
        }
    }
}
