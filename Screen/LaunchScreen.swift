//
//  LaunchScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 14/08/23.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        VStack {
            Image(Asset.splashScreenImage.name)
                .resizable()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .background(Color(Asset.launchScreenBackground.name))
    }
}
