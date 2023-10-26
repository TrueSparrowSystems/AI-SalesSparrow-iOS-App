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
            .font(.nunitoSemiBold(size: 12))
            .underline()
            .foregroundColor(Color(Asset.redHighlight.name))
            .accessibilityLabel(Text("txt_login_terms"))
        
        let termsTextWithLink = Text("[Terms and Conditions](https://drive.google.com/file/d/1pOQOLw_yt1aF9QXHlJag2YgaFmwtMf3Y/view)")
            .font(.nunitoSemiBold(size: 12))
            .foregroundColor(.clear)
            .accessibilityLabel(Text("txt_terms"))
        
        let privacyText = Text("Privacy Policy")
            .font(.nunitoSemiBold(size: 12))
            .underline()
            .foregroundColor(Color(Asset.redHighlight.name))
            .accessibilityLabel(Text("txt_login_privacy"))
        
        let privacyTextWithLink = Text("[Privacy Policy](https://drive.google.com/file/d/1kccg9XL2D0QEtCV09Bn8icStNX1PAF5E/view)")
            .font(.nunitoSemiBold(size: 12))
            .foregroundColor(.clear)
            .accessibilityLabel(Text("txt_privacy"))
        
        let agreementText = Text("By continuing, you're agreeing to the truesparrow's ")
            .foregroundColor(Color(Asset.termsPrimary.name))
            .font(.nunitoSemiBold(size: 12))
        
        let andText = Text(" and ")
            .foregroundColor(Color(Asset.termsPrimary.name))
            .font(.nunitoSemiBold(size: 12))
        
        return ZStack {
            HStack {
                agreementText + termsText + andText + privacyText
            }
            HStack {
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
