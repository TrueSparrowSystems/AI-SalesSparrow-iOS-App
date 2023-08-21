//
//  UIScreenExtension.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 09/08/23.
//

import SwiftUI

// An extention to get top safe area insets of UI screen.
extension UIScreen {
    static var topSafeArea: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets.top) ?? 0
    }
}
