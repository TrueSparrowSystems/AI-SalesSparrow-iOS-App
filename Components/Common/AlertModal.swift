//
//  AlertModal.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 16/08/23.
//

import SwiftUI

struct AlertModal: View {
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    AlertViewModel.shared.dismissAlert()
                }
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text(AlertViewModel.shared.alert?.title ?? "")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("txt_alert_title")
                    
                    AlertViewModel.shared.alert?.message
                        .font(.system(size: 13))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("txt_alert_message")
                }
                .padding()
                
                Divider()
                
                HStack(spacing: 0) {
                    Button(action: {
                        // Handle cancel action
                        AlertViewModel.shared.dismissAlert()
                    }, label: {
                        Text(AlertViewModel.shared.alert?.cancelText ?? "Cancel")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color(Asset.cancelButtonForeground.name))
                            .accessibilityIdentifier("txt_alert_cancel")
                    }
                    )
                    .accessibilityIdentifier("btn_alert_cancel")
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Divider()
                            .frame(maxWidth: 1, maxHeight: .infinity), alignment: .trailing
                    )
                    
                    Button(action: {
                        // handle alert submit action
                        AlertViewModel.shared.alert?.onSubmitPress()
                        AlertViewModel.shared.dismissAlert()
                    }, label: {
                        Text(AlertViewModel.shared.alert?.submitText ?? "Submit")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(Asset.alertSubmitButtonForeground.name))
                            .accessibilityIdentifier("txt_alert_submit")
                    }
                    )
                    .accessibilityIdentifier("btn_alert_submit")
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color(Asset.alertModalBackground.name))
            .cornerRadius(14)
            .frame(width: 270)
        }
        
    }
}
