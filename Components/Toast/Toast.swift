//
//  Toast.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 08/08/23.
//

import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "CheckWithRoundedWhiteBG"
        case .error: return "xmark.circle.fill"
        }
    }
}
