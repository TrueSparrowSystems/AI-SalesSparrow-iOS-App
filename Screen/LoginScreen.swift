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
                        .frame(width: 160, height: 80)
                        .padding(.bottom, 16)
                    Text("Your Salesforce app with AI powered recommendations")
                        .padding(.bottom, 16)
                        .font(.custom("Nunito-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("LoginScreenText"))
                    
                    HStack{
                        Image("NoteIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                        Text("Notes")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Image("TasksIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                        Text("Tasks")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Image("EventsIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                        Text("Events")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Image("OpportunitiesIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(.horizontal, 2)
                        Text("Opportunities")
                            .font(.custom("Nunito-Regular",size: 14))
                            .foregroundColor(Color("TextPrimary"))
                            .lineLimit(1)
                        
                    }
                    // 1px divider line
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                        .padding(.vertical, 16)
                    
                    Text("Create Account")
                        .font(.custom("Nunito-SemiBold", size: 18))
                        .foregroundColor(Color("LoginScreenText"))
                    
                    Button(action: {
                        isLoginInProgress = true
                        loginScreenViewModel.fetchSalesforceConnectUrl(onSuccess: {url in
                            openURL(URL(string: url)!)
                        }, onFailure: {
                            isLoginInProgress = false
                        })
                    }, label:{
                        HStack(alignment: .center, spacing: 0){
                            if(isLoginInProgress){
                                ProgressView()
                            }else{
                                Image("SalesforceIcon")
                                    .resizable()
                                    .frame(width: 26, height: 18)
                                Text("Continue with Salesforce")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .font(.custom("Nunito-Medium", size: 16))
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
