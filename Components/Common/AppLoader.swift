//
//  AppLoader.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/08/23.
//

import SwiftUI

struct AppLoader: View {
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .tint(.white)
                .controlSize(.large)
                .accessibilityAddTraits(.isImage)
                .accessibilityIdentifier("app_loader")
        }
    }
}
