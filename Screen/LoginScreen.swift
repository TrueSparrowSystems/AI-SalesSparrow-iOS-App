//
//  LoginScreen.swift
//  SalesSparrowTests
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var loginScreenViewModel: LoginScreenViewModel
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    Image(Asset.appLogo.name)
                        .resizable()
                        .frame(width: 220, height: 50)
                        .padding(.bottom, 16)
                        .accessibilityIdentifier("img_login_app_logo")
                    
                    Text("Your Salesforce app with AI powered recommendations")
                        .padding(.bottom, 16)
                        .font(.nunitoRegular(size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(Asset.loginScreenText.name))
                        .accessibilityIdentifier("txt_login_app_description")
                    
                    HStack {
                        Image(Asset.noteIcon.name)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_note_icon")
                        
                        Text("Notes")
                            .font(.nunitoRegular(size: 14))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .accessibilityIdentifier("txt_login_note")
                        
                        Image(Asset.tasksIcon.name)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_tasks_icon")
                        
                        Text("Tasks")
                            .font(.nunitoRegular(size: 14))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .accessibilityIdentifier("txt_login_tasks")
                        
                        Image(Asset.eventsIcon.name)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_events_icon")
                        
                        Text("Events")
                            .font(.nunitoRegular(size: 14))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .accessibilityIdentifier("txt_login_events")
                        
                        Image(Asset.opportunitiesIcon.name)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_opportunities_icon")
                        
                        Text("Opportunities")
                            .font(.nunitoRegular(size: 14))
                            .foregroundColor(Color(Asset.textPrimary.name))
                            .lineLimit(1)
                            .accessibilityIdentifier("txt_login_opportunities")
                        
                    }
                    
                    Button(action: {
                        loginScreenViewModel.fetchSalesforceConnectUrl(onSuccess: {url in
                            SafariWebViewModel.shared.showWebView(_url: url)
                        }, onFailure: {})
                    }, label: {
                        HStack(alignment: .center, spacing: 0) {
                            if loginScreenViewModel.isLoginInProgress {
                                ProgressView()
                                    .tint(Color(Asset.loginButtonPrimary.name))
                            } else {
                                Image(Asset.salesforceIcon.name)
                                    .resizable()
                                    .frame(width: 26, height: 18)
                                    .accessibilityIdentifier("img_login_salesforce_icon")
                                
                                Text("Continue with Salesforce")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .font(.nunitoMedium(size: 16))
                                    .accessibilityIdentifier("txt_login_continue_salesforce")
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 46)
                        .background(
                            LinearGradient(gradient: Gradient(stops: [.init(color: Color(Asset.loginButtonSecondary.name), location: 0), .init(color: Color(Asset.loginButtonPrimary.name), location: 4)]), startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.top, 20)
                        
                    }
                    )
                    .disabled(loginScreenViewModel.isLoginInProgress)
                    .accessibilityIdentifier("btn_connect_salesforce")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                .background(.white)
            }
            .padding(.horizontal, 20)
            Spacer()
            TermsBottomStrip()
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
            
        }
        .background(Color(Asset.background.name))
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(LoginScreenViewModel())
            .environmentObject(UserStateViewModel.shared)
            .environmentObject(Environments.shared)
    }
}
