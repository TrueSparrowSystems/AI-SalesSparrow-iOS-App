//
//  CreateNoteScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import SwiftUI

struct CreateNoteScreen: View {
    @EnvironmentObject var createNoteScreenViewModel: CreateNoteScreenViewModel
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
    @State var propagateClick = 0
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(isNoteSaved ? "Done" : "Cancel")
                    .font(.nunitoBold(size: 14))
                    .padding(.vertical, 10)
                    .foregroundColor(Color(Asset.cancelText.name))
                    .accessibilityIdentifier(isNoteSaved ? "btn_done_create_note" : "btn_cancel_create_note")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Button(action: {
                    isSaveInProgress = true
                    createNoteScreenViewModel.createNote(text: text, accountId: accountId, onSuccess: {
                        isSaveInProgress = false
                        isNoteSaved = true
                    }, onFailure: {
                        isSaveInProgress = false
                    })
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        if isSaveInProgress {
                            ProgressView()
                                .tint(Color(Asset.loginButtonPrimary.name))
                                .controlSize(.small)
                            Text("Saving")
                                .foregroundColor(.white)
                                .font(.nunitoMedium(size: 12))
                                .accessibilityIdentifier("txt_create_note_saving")
                            
                        } else if isNoteSaved {
                            Image(Asset.checkMark.name)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_checkmark")
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.nunitoMedium(size: 12))
                                .accessibilityIdentifier("txt_create_note_saved")
                        } else {
                            Image(Asset.salesforceIcon.name)
                                .resizable()
                                .frame(width: 17, height: 12)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier("img_create_note_salesforce_icon")
                            
                            Text("Save")
                                .foregroundColor(.white)
                                .font(.nunitoMedium(size: 12))
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
                .disabled(isNoteSaved || isSaveInProgress || accountId.isEmpty || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(accountId.isEmpty || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.7 : 1)
            }
            .padding(.vertical, 12)
            
            HStack {
                Image(Asset.accountIcon.name)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .accessibilityIdentifier("img_create_note_account_icon")
                
                Text("Account")
                    .foregroundColor(Color(Asset.textPrimary.name))
                    .font(.nunitoRegular(size: 12))
                    .accessibilityIdentifier("txt_create_note_account")
                if isAccountSelectable && !(isNoteSaved || isSaveInProgress) {
                    Button(action: {showAccountSearchView = true}, label: {
                        HStack(alignment: .center) {
                            Text(accountId.isEmpty ? "Select": accountName)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 6)
                                .foregroundColor(Color(Asset.redHighlight.name))
                                .font(.nunitoLight(size: 14))
                                .accessibilityIdentifier(accountId.isEmpty ? "txt_create_note_select_account" : "txt_create_note_selected_account")
                            Image(Asset.arrowDown.name)
                                .frame(width: 7, height: 4)
                                .padding(.trailing, 6)
                                .accessibilityIdentifier( "img_create_note_select_account")
                        }
                    }
                    )
                    .accessibilityIdentifier("btn_create_note_select_account")
                    .background(Color(Asset.selectAccountDropdownBG.name))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    .sheet(isPresented: $showAccountSearchView, onDismiss: {
                    }, content: {
                        AccountSearchView(isPresented: $showAccountSearchView, isCreateNoteFlow: true, onNoteCreateSelected: { _accountId, _accountName in
                            accountId = _accountId
                            accountName = _accountName
                        })
                    }
                    )
                    
                } else {
                    HStack(alignment: .center) {
                        Text(accountName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .foregroundColor(Color(Asset.redHighlight.name))
                            .font(.nunitoBold(size: 14))
                            .accessibilityIdentifier("txt_create_note_selected_account")
                    }
                    .background(Color(Asset.selectAccountDropdownBG.name))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.top, 12)
            ScrollView {
                HStack {
                    if isNoteSaved || isSaveInProgress {
                        Text(text)
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.nunitoSemiBold(size: 18))
                        
                    } else {
                        TextField("Add Note", text: $text, axis: .vertical)
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .font(.nunitoSemiBold(size: 18))
                            .focused($focused)
                            .accessibilityIdentifier("et_create_note")
                            .onTapGesture {
                                // Do nothing. Kept on tap here to override tap action over parent tap action
                            }
                            .lineLimit(4...)
                        
                    }
                }
                .contentShape(Rectangle())
                
                if isNoteSaved {
                    VStack {
                        if createNoteScreenViewModel.isSuggestionGenerationInProgress {
                            HStack {
                                Image(Asset.sparkle.name)
                                Text("Getting recommendations")
                                    .foregroundColor(Color(Asset.textPrimary.name))
                                    .font(.nunitoSemiBold(size: 16))
                                Spacer()
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                ShimmerView(size: CGSize(width: 356, height: 26))
                                ShimmerView(size: CGSize(width: 356, height: 64))
                                HStack {
                                    ShimmerView(size: CGSize(width: 72, height: 33))
                                    ShimmerView(size: CGSize(width: 72, height: 33))
                                }
                            }
                        } else if  createNoteScreenViewModel.suggestedData.add_task_suggestions?.isEmpty ?? true && createNoteScreenViewModel.suggestedData.add_event_suggestions?.isEmpty ?? true { // check for count of suggested task and event array
                            // Show no recommendation message
                            VStack(spacing: 0) {
                                Image(Asset.check.name)
                                    .frame(width: 28, height: 28, alignment: .center)
                                
                                Text("You are all set, no recommendation for now!")
                                    .foregroundColor(Color(Asset.termsPrimary.name))
                                    .font(.nunitoSemiBold(size: 14))
                                    .frame(alignment: .center)
                                    .padding(.top, 16)
                                    .accessibilityIdentifier("txt_create_note_no_recommendations")
                            }
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1, 5]))
                                    .foregroundColor(Color(Asset.textPrimary.name))
                            )
                        } else {
                            HStack {
                                Image(Asset.sparkle.name)
                                Text("We have some recommendations")
                                    .foregroundColor(Color(Asset.textPrimary.name))
                                    .font(.nunitoSemiBold(size: 16))
                                    .accessibilityIdentifier("txt_create_note_recommendations")
                                
                                Spacer()
                                Button {
                                    isPopoverVisible.toggle()
                                } label: {
                                    Image(Asset.addIcon.name)
                                        .frame(width: 20, height: 20)
                                }
                                .accessibilityIdentifier("btn_create_note_popover_add_recommendation")
                            }
                            let addTaskSuggestions = createNoteScreenViewModel.suggestedData.add_task_suggestions ?? []
                            ForEach(Array(addTaskSuggestions.enumerated()), id: \.offset) { index, suggestion in
                                SuggestedTaskCardView(accountId: accountId, suggestion: suggestion, index: index, propagateClick: $propagateClick)
                            }
                            
                            let addEventSuggestions = createNoteScreenViewModel.suggestedData.add_event_suggestions ?? []
                            ForEach(Array(addEventSuggestions.enumerated()), id: \.offset) { index, suggestion in
                                SuggestedEventCardView(accountId: accountId, suggestion: suggestion, index: index, propagateClick: $propagateClick)
                            }
                        }
                        
                    }
                    .overlay(alignment: .topTrailing) {
                        if isPopoverVisible {
                            AddButtonPopoverComponent(isPopoverVisible: $isPopoverVisible, accountId: accountId)
                                .offset(x: 35, y: 25)
                        }
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            propagateClick += 1
                        }
                    )
                    .simultaneousGesture(
                        DragGesture().onChanged {_ in
                            propagateClick += 1
                        }
                    )
                }
            }
            .scrollIndicators(.hidden)
            .gesture(DragGesture().onChanged {_ in
                if isPopoverVisible {
                    isPopoverVisible.toggle()
                } else {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                focused = true
            }
            isPopoverVisible = false
        }
        .onTapGesture {
            if isPopoverVisible {
                isPopoverVisible.toggle()
            } else {
                focused = false
            }
        }
    }
}
