//
//  ExpandableTextView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import SwiftUI

 /// A view representing an expandable text view with optional text highlighting based on a provided pattern.
struct ExpandableTextView: View {
    // The binding to the text displayed in the text view.
    @Binding var text: String
    // The pattern used to highlight specific text in the text view (optional).
    var highlightPattern: String?
    
    // The dynamic height of the text view, used to adjust the text view's frame to fit the content.
    @State private var dynamicHeight: CGFloat = 32
    
    // The minimum height of the text view when collapsed.
    let minHeight: CGFloat = 32
    
    // The maximum height of the text view when expanded.
    let maxHeight: CGFloat = 200
    
    /// The view for the expandable text view.
    var body: some View {
        ZStack(alignment: .topLeading) {
            // The actual TextView displayed when there is text.
            TextView(text: $text, dynamicHeight: $dynamicHeight, highlightPattern: highlightPattern)
                .frame(height: min(max(dynamicHeight, minHeight), maxHeight))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 1))
                .clipped()
            if text.isEmpty {
                // Placeholder text when the text view is empty and not focused.
                Text("Please Describe here")
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }
}

/// A UIViewRepresentable for a UITextView with optional text highlighting.
struct TextView: UIViewRepresentable {
    // The binding to the text displayed in the text view.
    @Binding var text: String
    
    // The dynamic height of the text view, used to adjust the text view's frame to fit the content.
    @Binding var dynamicHeight: CGFloat
    
    // The pattern used to highlight specific text in the text view (optional).
    let highlightPattern: String?
    
    /// Creates the underlying UITextView instance.
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        return textView
    }
    
    /// Updates the UITextView instance with the provided text and adjusts the height based on content.
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        DispatchQueue.main.async {
            self.dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: .infinity)).height
        }
        highlightText(in: uiView)
    }
    
    /// Creates the coordinator instance for the UITextView.
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    /// The coordinator for the UITextView, used to handle text changes.
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            self.parent.highlightText(in: textView)
        }
    }
    
    /// Highlights the text based on the provided pattern, if available.
    private func highlightText(in textView: UITextView) {
        guard let pattern = highlightPattern else { return }
        
        // Create an attributed string from the text view's text.
        let attributedText = NSMutableAttributedString(string: textView.text)

        // Create a regular expression from the pattern.
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        // Highlight all matches of the pattern in the text view.
        if let matches = regex?.matches(in: textView.text, options: [], range: NSRange(location: 0, length: textView.text.count)) {
            for match in matches {
                // Highlight the match in purple.
                attributedText.addAttribute(.foregroundColor, value: UIColor.purple, range: match.range)
            }
        }
        
        // Set the text view's attributed text to the highlighted text.
        textView.attributedText = attributedText
    }
}
