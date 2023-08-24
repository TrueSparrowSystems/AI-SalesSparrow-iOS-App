//
//  DateTimePicker.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        
        // Date and time picker
        DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents:  [.date])
            .datePickerStyle(.compact)
            .labelsHidden()
            .accentColor(Color.white)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

struct TimePickerView: View {
    @State private var selectedTime = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            // Date and time picker
            VStack(spacing: 8) {
                HStack {
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
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}
