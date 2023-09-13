//
//  ShimmerLoader.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 13/09/23.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Text("Shimmer")
            .foregroundColor(.blue)
            .font(.system(size: 24, weight: .bold))
            .opacity(isAnimating ? 0.5 : 1)
            .onAppear() {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
                    isAnimating.toggle()
                }
            }
    }
}
