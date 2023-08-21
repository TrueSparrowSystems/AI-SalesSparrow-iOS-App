//
//  LoginScreen.swift
//  SalesSparrowTests
//
//  Created by Mohit Charkha on 31/07/23.
//


import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var loginScreenViewModel : LoginScreenViewModel
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    @Environment(\.openURL) var openURL
    @State var isLoginInProgress = false
    @EnvironmentObject var environment: Environments
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 220, height: 50)
                        .padding(.bottom, 16)
                        .accessibilityIdentifier("img_login_app_logo")
                    
                    Text("Your Salesforce app with AI powered recommendations")
                        .padding(.bottom, 16)
                        .font(.custom("Nunito-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("LoginScreenText"))
                        .accessibilityIdentifier("txt_login_app_description")
                    
                    HStack{
                        Image("NoteIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_note_icon")
                        
                        Text("Notes")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                            .accessibilityIdentifier("txt_login_note")
                        
                        Image("TasksIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_tasks_icon")

                        Text("Tasks")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                            .accessibilityIdentifier("txt_login_tasks")
                        
                        Image("EventsIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_events_icon")

                        Text("Events")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                            .accessibilityIdentifier("txt_login_events")
                        
                        Image("OpportunitiesIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                            .accessibilityIdentifier("img_login_opportunities_icon")

                        Text("Opportunities")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                            .lineLimit(1)
                            .accessibilityIdentifier("txt_login_opportunities")
                        
                    }
                    // 1px divider line
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                        .padding(.vertical, 16)
                    
                    Text("Create Account")
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .foregroundColor(Color("LoginScreenText"))
                        .accessibilityIdentifier("txt_login_create_account")
                    
                    Button(action: {
                        isLoginInProgress = true
                        loginScreenViewModel.fetchSalesforceConnectUrl(onSuccess: {url in
                            openURL(URL(string: url)!)
                            isLoginInProgress = false
                        }, onFailure: {
                            isLoginInProgress = false
                        })
                    }, label:{
                        HStack(alignment: .center, spacing: 0){
                            if(isLoginInProgress){
                                ProgressView()
                                    .tint(Color("LoginButtonPrimary"))
                            }else{
                                Image("SalesforceIcon")
                                    .resizable()
                                    .frame(width: 26, height: 18)
                                    .accessibilityIdentifier("img_login_salesforce_icon")

                                Text("Continue with Salesforce")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .font(.custom("Nunito-Medium", size: 16))
                                    .accessibilityIdentifier("txt_login_continue_salesforce")
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 46)
                        .background(
                            
                            LinearGradient(gradient: Gradient(stops: [.init(color: Color("LoginButtonSecondary"), location: 0), .init(color: Color("LoginButtonPrimary"), location: 4)]), startPoint: .top, endPoint: .bottom)
                            
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                    }
                    )
                    .disabled($isLoginInProgress.wrappedValue)
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
        .background(Color("Background"))
        .onChange(of: environment.vars["auth_code"], perform: { _ in
            isLoginInProgress = true
            loginScreenViewModel.salesforceConnect(authCode: environment.vars["auth_code"], onSuccess: {
                isLoginInProgress = false
            }, onFailure: {
                isLoginInProgress = false
            })
        })
        
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
