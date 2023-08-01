//
//  TermsBottomStrip.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 01/08/23.
//

import Foundation
import SwiftUI

struct TermsBottomStrip: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        HStack{
            Text("By continuing, you're agreeing to the truesparrow's ")
                .foregroundColor(Color("T&CPrimary"))
                .font(.custom("Nunito-SemiBold" ,size: 12))
            + Text("Terms and Conditions")
                .foregroundColor(Color("T&CHighlight"))
                .font(.custom("Nunito-SemiBold" ,size: 12))
                .underline()
            //                .onTapGesture{
            //                    openURL(URL(string: "www.truesparrow.com")!)
            //                }
            + Text(" and ")
                .foregroundColor(Color("T&CPrimary"))
                .font(.custom("Nunito-SemiBold" ,size: 12))
            + Text("Privacy Policy")
                .foregroundColor(Color("T&CHighlight"))
                .font(.custom("Nunito-SemiBold" ,size: 12))
                .underline()
            //                .onTapGesture{
            //                    openURL(URL(string: "www.truesparrow.com")!)
            //                }
        }
        
    }
}

struct TermsBottomStrip_Previews: PreviewProvider {
    static var previews: some View {
        TermsBottomStrip()
    }
}
