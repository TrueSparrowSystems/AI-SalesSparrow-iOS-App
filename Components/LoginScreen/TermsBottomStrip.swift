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
        let termsText = Text("[Terms and Conditions](https://truesparrow.com)")
            .font(.custom("Nunito-SemiBold" ,size: 12))
            .underline()
            .foregroundColor(Color("RedHighlight"))
            .accessibilityLabel(Text("txt_terms"))
        
        let privacyText = Text("[Privacy Policy](https://truesparrow.com)")
            .font(.custom("Nunito-SemiBold" ,size: 12))
            .underline()
            .foregroundColor(Color("RedHighlight"))
            .accessibilityLabel(Text("txt_privacy"))
        
        
        let agreementText = Text("By continuing, you're agreeing to the truesparrow's ")
            .foregroundColor(Color("TermsPrimary"))
            .font(.custom("Nunito-SemiBold" ,size: 12))
        
        let andText = Text(" and ")
            .foregroundColor(Color("TermsPrimary"))
            .font(.custom("Nunito-SemiBold" ,size: 12))

        return HStack{
            agreementText + termsText + andText + privacyText
        }
    }
}

struct TermsBottomStrip_Previews: PreviewProvider {
    static var previews: some View {
        TermsBottomStrip()
    }
}
