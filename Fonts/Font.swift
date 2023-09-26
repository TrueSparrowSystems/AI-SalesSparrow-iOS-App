//
//  Font.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 25/09/23.
//

import SwiftUI

extension Font {
    static func nunitoLight(size: CGFloat) -> Font {
        return Font.custom("Nunito-Light", size: size)
    }
    static func nunitoRegular(size: CGFloat) -> Font {
        return Font.custom("Nunito-Regular", size: size)
    }
    static func nunitoMedium(size: CGFloat) -> Font {
        return Font.custom("Nunito-Medium", size: size)
    }
    static func nunitoSemiBold(size: CGFloat) -> Font {
        return Font.custom("Nunito-SemiBold", size: size)
    }
    static func nunitoBold(size: CGFloat) -> Font {
        return Font.custom("Nunito-Bold", size: size)
    }
}
