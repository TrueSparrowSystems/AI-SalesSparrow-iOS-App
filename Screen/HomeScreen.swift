//
//  HomeScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 03/08/23.
//

import SwiftUI

struct HomeScreen: View{
    var body: some View{
        NavigationLink(destination: CreateNoteScreen()){
            Text("Navigate to Create Note Screen")
        }
        .navigationTitle("")
    }
}
