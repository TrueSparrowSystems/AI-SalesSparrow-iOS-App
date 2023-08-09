//
//  ToastView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 08/08/23.
//

import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 12) {
                Image(style.iconFileName)
                Text(message)
                    .font(.custom("Nunito-Medium", size: 16))
                    .foregroundColor(Color(.white))
            }
            .padding()
            .padding(.top, UIScreen.topSafeArea)
            .frame(minWidth: 0, maxWidth: width)
            .background(style.themeColor)
        }
        .edgesIgnoringSafeArea(.top)
    }
}
