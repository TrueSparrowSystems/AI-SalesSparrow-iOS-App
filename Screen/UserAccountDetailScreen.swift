//
//  UserAccountDetailScreen.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 16/08/23.
//


import SwiftUI

struct UserAccountDetailScreen: View {
    let appVersion: String = DeviceSettingManager.shared.deviceHeaderParams["X-SalesSparrow-App-Version"] as! String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userStateViewModel : UserStateViewModel
    
    var body: some View {
        VStack (spacing: 16) {
            HStack{
                Image("ArrowLeft")
                    .frame(width: 24, height: 24)
                    .accessibilityIdentifier("img_user_account_detail_dismiss")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
            }
            
            VStack (spacing: 24) {
                HStack{
                    Text(BasicHelper.getInitials(from: userStateViewModel.currentUser.name))
                        .frame(width: 30, height: 30)
                        .font(.custom("Nunito-Bold", size: 9))
                        .foregroundColor(Color.black)
                        .background(Color("UserBubble"))
                        .clipShape(Circle())
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
                                AlertViewModel.shared.showAlert(
                                    _alert: Alert(
                                        title: "Disconnect Salesforce",
                                        message: Text("This will \(Text("delete your account").font(.system(size: 13, weight: .bold))) and all details associated with it. This is an irreversible process, are you sure you want to do this?"),
                                        submitText: "Disconnect",
                                        onSubmitPress: {userStateViewModel.disconnectUser()}
                                    )
                                )
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
                        
                        
                        DisconnectDescription()
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
        
        .background(Color("Background"))
    }
}

struct DisconnectDescription: View {
    
    var body: some View {
        let t1 = Text("Disconnecting Salesforce will also ")
            .font(.custom("Nunito-SemiBold", size: 14))
            .foregroundColor(Color("TextPrimary"))
        
        let t2 = Text("delete your account")
            .font(.custom("Nunito-SemiBold", size: 14))
            .foregroundColor(Color("RedHighlight"))
        
        let t3 = Text(" and all details associated with it.")
            .font(.custom("Nunito-SemiBold", size: 14))
            .foregroundColor(Color("TextPrimary"))
        
        return t1 + t2 + t3
        
    }
}

struct AccountDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountDetailScreen()
    }
}
