//
//  DateTimePicker.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

struct DateTimePicker: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            // Date and time picker
            VStack(spacing: 8) {
                HStack {
                    DatePicker("", selection: $selectedDate, displayedComponents:  [.date])
                        .datePickerStyle(.automatic)
                        .accentColor(Color(hex: "#f5aa42"))
                        .foregroundColor(.blue)
                    
                    DatePicker("", selection: $selectedTime, displayedComponents:  [.hourAndMinute])
                        .datePickerStyle(.automatic)
                        .accentColor(Color(hex: "#f5aa42"))
                        .foregroundColor(.blue)
                }
                .frame(width: 324, height: 50)
                .padding(8)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}



struct CustomComponent_Previews: PreviewProvider {
    static var previews: some View {
        DateTimePicker()
    }
}
