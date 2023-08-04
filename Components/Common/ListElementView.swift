//
//  ListElementView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI
import CoreData

struct ListElementView: View {
    @Environment(\.openURL) var openURL
    var id: String
    
    var body: some View {
        let taskDetail = try? TasksRepository.shared.getById(id)
        Text(taskDetail?.status ?? "")
    }
}
