//
//  ColorExtension.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: Double(rgbValue & 0x0000FF) / 255.0)
    }
}
