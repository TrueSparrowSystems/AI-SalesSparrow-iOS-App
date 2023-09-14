//
//  DateTimePicker.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    var onTap: (() -> Void)?
    
    var body: some View {
        
        // Date picker
        DatePicker("", selection: $selectedDate, displayedComponents:  [.date])
            .datePickerStyle(.compact)
            .labelsHidden()
            .accentColor(Color.blue)
            .onTapGesture {
                onTap?()
            }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

struct TimePickerView: View {
    @Binding var selectedTime: Date
    var onTap: (() -> Void)?
    
    var body: some View {
        // Time picker
        DatePicker("", selection: $selectedTime, displayedComponents:  [.hourAndMinute])
            .datePickerStyle(.automatic)
            .accentColor(Color.blue)
            .foregroundColor(.blue)
            .onTapGesture {
                onTap?()
            }
        
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}
