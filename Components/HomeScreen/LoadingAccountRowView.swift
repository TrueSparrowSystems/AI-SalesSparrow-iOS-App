//
//  LoadingAccountRowView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 13/09/23.
//

import SwiftUI

struct LoadingAccountRowView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ShimmerView(size: CGSize(width: 102, height: 13))
            ShimmerView(size: CGSize(width: 48, height: 16))
                .padding(.top, 8)
            ShimmerView(size: CGSize(width: 100, height: 13))
                .padding(.top, 4)
            
            ShimmerView(size: CGSize(width: 60, height: 16))
                .padding(.top, 20)
            ShimmerView(size: CGSize(width: 255, height: 15))
                .padding(.top, 8)
            
            ShimmerView(size: CGSize(width: 250, height: 12))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(Asset.cardBackground.name))
        .cornerRadius(5) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(Asset.cardBorder.name), lineWidth: 1)
        )
        .padding(.bottom, 10)
    }
}

struct LoadingAccountRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoadingAccountRowView()
        }
    }
}
