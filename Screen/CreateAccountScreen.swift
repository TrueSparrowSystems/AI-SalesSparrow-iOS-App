//
//  CreateAccountScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 26/10/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var createAccountScreenViewModel: CreateAccountScreenViewModel
    @State private var accountDetailForm: [AccountField] = []
    @State private var selectedValues: [String] = []
    @State var isAddAccountInProgress = false
    
    var body: some View {
        VStack {
            ForEach(accountDetailForm.indices, id: \.self) { index in
                let field = accountDetailForm[index]
                let selectedValue = $selectedValues[index]
                
                VStack {
                    HStack {
                        Text(field.label.uppercased())
                            .font(.nunitoBold(size: 12))
                            .foregroundColor(Color(Asset.termsPrimary.name))
                            .tracking(0.5)
                        Spacer()
                    }
                    HStack {
                        if field.type == "string" || field.type == "url" {
                            TextField(field.label, text: selectedValue)
                                .font(.nunitoRegular(size: 16))
                                .foregroundColor(Color(Asset.luckyPoint.name))
                                .accessibilityIdentifier("text_field_" + field.name)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                )
                        } else if field.type == "picklist", let picklistValues = field.picklistValues {
                            Picker(field.label, selection: selectedValue) {
                                ForEach(picklistValues, id: \.value) { picklistValue in
                                    Text(picklistValue.label ?? "").tag(picklistValue.value ?? "")
                                        .background(Color.white)
                                        .foregroundColor(Color(Asset.luckyPoint.name))
                                        .accessibilityIdentifier("picklist_value_" + (picklistValue.value ?? ""))
                                }
                            }
                            .pickerStyle(.menu)
                            .accessibilityIdentifier("picklist_" + field.name)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                        }
                        Spacer()
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
                    print(selectedValues)
                    createAccountScreenViewModel.createAccount(onSuccess: {accountId in
                        isAddAccountInProgress = false
                    }, onFailure: {
                        isAddAccountInProgress = false
                    })
                }, label: {
                    Text("Create Account")
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
                selectedValues = Array(repeating: "", count: accountDetailForm.count)
                
                for (index, field) in accountDetailForm.enumerated() {
                    selectedValues[index] = field.defaultValue ?? (field.picklistValues?.first?.value ?? "")
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
                Image(Asset.arrowLeft.name)
                    .frame(width: 24, height: 24)
                Text("Add New Account")
                    .font(.nunitoSemiBold(size: 24))
                    .accessibilityIdentifier("txt_add_new_account")
                    .foregroundColor(Color(Asset.loginScreenText.name))
            }
            .foregroundColor(Color(Asset.saveButtonBackground.name))
        })
        .accessibilityIdentifier("btn_account_detail_back")
    }
}
