//
//  UserAccountDetailScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 16/08/23.
//


import SwiftUI

struct UserAccountDetailScreen: View {
    let appVersion: String = DeviceSettingManager.shared.deviceHeaderParams["X-SalesSparrow-App-Version"] as! String
    
    @State var disconnectSalesforceModel: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    
    var body: some View {
        ZStack {
            VStack (spacing: 16) {
                HStack{
                    Image("Close")
                        .frame(width: 32,height: 32)
                        .accessibilityIdentifier("img_user_account_detail_dismiss")
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer()
                }
                
                VStack (spacing: 24) {
                    HStack{
                        Text(BasicHelper.getInitials(from: userStateViewModel.currentUser.name))
                            .frame(width: 32, height: 32)
                            .font(.custom("Nunito-Bold", size: 7))
                            .background(Color("UserBubble"))
                            .clipShape(RoundedRectangle(cornerRadius: 47))
                            .accessibilityIdentifier("img_user_account_detail_user_initials")
                        
                        Text(userStateViewModel.currentUser.name)
                            .font(.custom("Nunito-Medium", size: 14))
                            .foregroundColor(Color("TextPrimary"))
                            .accessibilityIdentifier("txt_user_account_detail_user_name")
                        
                        Spacer()
                    }
                    
                    VStack {
                        VStack(spacing: 10) {
                            HStack {
                                Button(action: {
                                    disconnectSalesforceModel = true
                                }) {
                                    Image("ToggleButton")
                                }
                                .accessibilityIdentifier("img_user_account_detail_salesforce_disconnect")
                                
                                
                                Text("Disconnect Salesforce")
                                    .font(.custom("Nunito-SemiBold", size: 16))
                                    .foregroundColor(Color("TextPrimary"))
                                    .accessibilityIdentifier("txt_user_account_detail_salesforce_disconnect")
                                
                                Spacer()
                            }
                            .background(Color.white)
                            .cornerRadius(4)
                            .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 4))
                            
                            
                            Text("Disconnecting Salesforce will also delete your account and all details associated with it.")
                                .font(.custom("Nunito-SemiBold", size: 14))
                                .foregroundColor(Color("TextPrimary"))
                        }
                        .padding()
                        .background(Color("DisconnectBackground"))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    
                    HStack{
                        Image("SignOut")
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                            .accessibilityIdentifier("img_user_account_detail_logout")
                        
                        Text("Log Out")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(Color("TextPrimary"))
                            .accessibilityIdentifier("btn_user_account_detail_logout")
                            .onTapGesture {
                                userStateViewModel.logOut()
                            }
                        
                        
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                }
                .padding()
                
                Spacer()
                
                VStack{
                    Text("V\(appVersion)")
                        .font(.custom("Nunito-SemiBold", size: 12))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_user_account_detail_app_version")
                    
                    Text("Sales Sparrow by True Sparrow")
                        .font(.custom("Nunito-SemiBold", size: 16))
                        .foregroundColor(Color("TextPrimary"))
                        .accessibilityIdentifier("txt_user_account_detail_app_name")
                }
            }
            .padding()
            
            if disconnectSalesforceModel {
                DisconnectSalesforceModal(disconnectSalesforceModel: $disconnectSalesforceModel)
            }
        }
        .background(Color("Background"))
    }
}

struct AccountDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountDetailScreen()
    }
}
