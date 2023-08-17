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
        let termsText = Text("Terms and Conditions")
            .font(.custom("Nunito-SemiBold" ,size: 12))
            .underline()
            .foregroundColor(Color("RedHighlight"))
            .accessibilityLabel(Text("txt_login_terms"))
        
        let termsTextWithLink = Text("[Terms and Conditions](https://truesparrow.com)")
            .font(.custom("Nunito-SemiBold" ,size: 12))
            .foregroundColor(.clear)
            .accessibilityLabel(Text("txt_terms"))
        
        let privacyText = Text("Privacy Policy")
            .font(.custom("Nunito-SemiBold" ,size: 12))
            .underline()
            .foregroundColor(Color("RedHighlight"))
            .accessibilityLabel(Text("txt_login_privacy"))
        
        let privacyTextWithLink = Text("[Privacy Policy](https://truesparrow.com)")
            .font(.custom("Nunito-SemiBold" ,size: 12))
            .foregroundColor(.clear)
            .accessibilityLabel(Text("txt_privacy"))
        
        let agreementText = Text("By continuing, you're agreeing to the truesparrow's ")
            .foregroundColor(Color("TermsPrimary"))
            .font(.custom("Nunito-SemiBold" ,size: 12))
        
        let andText = Text(" and ")
            .foregroundColor(Color("TermsPrimary"))
            .font(.custom("Nunito-SemiBold" ,size: 12))
        
        return ZStack{
            HStack{
                agreementText + termsText + andText + privacyText
            }
            HStack{
                agreementText + termsTextWithLink + andText + privacyTextWithLink
            }
            .opacity(0.51)
            .zIndex(10)
        }
    }
}

struct TermsBottomStrip_Previews: PreviewProvider {
    static var previews: some View {
        TermsBottomStrip()
    }
}
