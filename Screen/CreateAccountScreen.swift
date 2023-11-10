//
//  CreateAccountScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 26/10/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    var accountId: String?
    var isEditFlow: Bool = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var createAccountScreenViewModel: CreateAccountScreenViewModel
    @State private var accountDetailForm: [String:AccountField] = [:]
    @State private var selectedValues: [String] = []
    @State private var selectedFieldindices: [String:Int] = [:]
    @State private var selectedDate: Date = Date()
    @State var isAddAccountInProgress = false
    
    var body: some View {
        VStack {
            ForEach(accountDetailForm.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                let index: Int = selectedFieldindices[key]!
                var selectedValue = $selectedValues[index]
                
                VStack {
                    if value.type == "string" || value.type == "url" || value.type == "double" || value.type == "percent" || value.type == "url" {
                        HStack {
                            Text(value.label.uppercased())
                                .font(.nunitoBold(size: 12))
                                .foregroundColor(Color(Asset.termsPrimary.name))
                                .tracking(0.5)
                            Spacer()
                        }
                        HStack {
                            
                            TextField("", text: selectedValue)
                                .font(.nunitoRegular(size: 16))
                                .foregroundColor(Color(Asset.luckyPoint.name))
                                .accessibilityIdentifier("text_field_" + value.name)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                )
                            Text("%")
                                .font(.nunitoBold(size: 14))
                                .foregroundColor(Color(Asset.termsPrimary.name))
                                .tracking(0.5)
                                .opacity(value.type == "percent" ? 1:0)
                            Spacer()
                        }
                        //                        else if value.type == "date" || value.type == "time" {
                        //                            ZStack {
                        //                                DatePickerView(selectedDate: $selectedDate, onTap: {
                        //                                    selectedValue.wrappedValue = BasicHelper.convertDateToString(selectedDate)
                        //                                })
                        //                                .background(.white)
                        //                                .cornerRadius(8)
                        //                                .accessibilityIdentifier("dp_add_event_select_start_date")
                        //                                .compositingGroup()
                        //                                .scaleEffect(x: 1.5, y: 1.5)
                        //                                .clipped()
                        //
                        //
                        //                                HStack(spacing: 0) {
                        //                                    Text(selectedValue.wrappedValue)
                        //                                        .foregroundColor(Color(Asset.termsPrimary.name))
                        //                                        .font(.nunitoBold( size: 12))
                        //                                        .tracking(0.5)
                        //                                        .padding(0)
                        //
                        //                                    Spacer()
                        //
                        //                                    Image(Asset.emptyCalendar.name)
                        //                                        .frame(width: 15, height: 15)
                        //                                        .padding(.leading, 10)
                        //                                }
                        //                                .accessibilityIdentifier("txt_add_event_select_start_date")
                        //                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        //                                .background(.white)
                        //                                .userInteractionDisabled()
                        //
                        //                            }
                        //                            .padding(.horizontal, 10)
                        //                            .frame(width: 160, height: 30)
                        //                            .overlay(
                        //                                RoundedRectangle(cornerRadius: 4)
                        //                                    .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
                        //                            )
                        //                        }
                        //                        else if value.type == "picklist", let picklistValues = value.picklistValues {
                        //                            Picker(value.label, selection: accountDetailForm[key].picklistValues) {
                        //                                ForEach(picklistValues) { picklistValue in
                        //                                    Text(picklistValue.label ?? "").tag(picklistValue.value ?? "")
                        //                                        .background(Color.white)
                        //                                        .foregroundColor(Color(Asset.luckyPoint.name))
                        ////                                        .accessibilityIdentifier("picklist_value_" + (picklistValue.value ?? ""))
                        //                                }
                        //                            }
                        //                            .pickerStyle(.menu)
                        ////                            .accessibilityIdentifier("picklist_" + value.name)
                        //                            .overlay(
                        //                                RoundedRectangle(cornerRadius: 5)
                        //                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        //                            )
                        //                        }
//                        Spacer()
                    }
                }
                .padding(.bottom, 8)
            }
            
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .font(.nunitoMedium(size: 12))
                        .tracking(0.5)
                        .foregroundColor(Color(Asset.cancelText.name))
                })
                .padding(.all, 8)
                .cornerRadius(5)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(Asset.cancelText.name), lineWidth: 1)
                )
                .padding(.trailing, 6)
                
                Button(action: {
                    isAddAccountInProgress = true
                    
                    var resultDictionary = [String: String]()
                    
                    var count = 0
                    for (fieldName, fieldValue) in accountDetailForm {
                        if fieldValue.type == "string" || fieldValue.type == "url" || fieldValue.type == "double" || fieldValue.type == "percent" || fieldValue.type == "url" {
                            resultDictionary[fieldName] = selectedValues[count]
                        }
                        count += 1
                    }
                    
                    
                    if !isEditFlow{
                        createAccountScreenViewModel.createAccount(selectedValuesMap: resultDictionary, onSuccess: {accountId in
                            isAddAccountInProgress = false
                            dismiss()
                        }, onFailure: {
                            isAddAccountInProgress = false
                            dismiss()
                        })
                    } else {
                        // trigger Edit API
                        createAccountScreenViewModel.editAccount(accountId: accountId!, selectedValuesMap: resultDictionary, onSuccess: {
                            isAddAccountInProgress = false
                            dismiss()
                        }, onFailure: {
                            isAddAccountInProgress = false
                            dismiss()
                        })
                    }
                    
                }, label: {
                    Text("\(isEditFlow ? "Save" : "Create Account")")
                        .font(.nunitoMedium(size: 12))
                        .tracking(0.5)
                        .foregroundColor(Color.white)
                })
                .padding(8)
                .background(Color(Asset.saveButtonBackground.name))
                .cornerRadius(5)
                
                Spacer()
            }
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            // Fetch account fields when the view appears
            createAccountScreenViewModel.fetchAccountFields(onSuccess: {
                accountDetailForm = createAccountScreenViewModel.accountFields.fields
                
                let numberOfFields = accountDetailForm.count
                selectedValues = Array(repeating: "", count: numberOfFields)
                var count: Int = 0;
                
                for (fieldName, fieldinfo) in accountDetailForm {
                    selectedValues[count] = fieldinfo.defaultValue ?? (fieldinfo.picklistValues.first??.value ?? "")
                    selectedFieldindices[fieldName] = count
                    count += 1
                }
            })
        }
    }
    
    private var backButton: some View {
        Button(action: {
            // This will dismiss the CreateAccountScreen and go back to the previous view
            dismiss()
        }, label: {
            HStack {
                //                Image(Asset.arrowLeft.name)
                //                    .frame(width: 24, height: 24)
                Text("\(isEditFlow ? "Edit" : "Add") New Account")
                    .font(.nunitoSemiBold(size: 24))
                    .accessibilityIdentifier("txt_add_new_account")
                    .foregroundColor(Color(Asset.loginScreenText.name))
            }
            .foregroundColor(Color(Asset.saveButtonBackground.name))
        })
        .accessibilityIdentifier("btn_account_detail_back")
    }
}
