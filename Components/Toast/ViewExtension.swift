//
//  ViewExtension.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 08/08/23.
//

import SwiftUI

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
