//
//  VerticalDividerRectangleView.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 23/08/23.
//
import SwiftUI

struct VerticalDividerRectangleView: View {
    var width: Double
    var color: Color
    
    var body: some View {
        Rectangle()
            .frame(width: width)
            .foregroundColor(color)
    }
}
