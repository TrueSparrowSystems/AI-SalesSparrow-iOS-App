//
//  CreateNoteScreen.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 02/08/23.
//

import SwiftUI

struct CreateNoteScreen : View {
    
    @State var text: String = ""
    
    var body: some View {
        VStack{
            Text("Create Note Screen")
        }
    }
}

struct CreateNoteScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteScreen()
    }
}
