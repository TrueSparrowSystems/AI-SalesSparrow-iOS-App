//
//  HTMLTextView.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 14/08/23.
//

import SwiftUI

struct HTMLTextView: UIViewRepresentable {
    let htmlText: String
    let textColor: UIColor
    let font: UIFont
    let backgroundColor: UIColor
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.contentMode = .top
        textView.backgroundColor = backgroundColor
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if let attributedString = htmlText.htmlToAttributedString(with: textColor, font: font) {
            uiView.attributedText = attributedString
        } else {
            uiView.attributedText = NSAttributedString(string: htmlText)
        }
        uiView.backgroundColor = backgroundColor // Update background color when updating the view
    }
}

extension String {
    func htmlToAttributedString(with textColor: UIColor, font: UIFont) -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: font
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.length))
            return mutableAttributedString
        }
        return nil
    }
}
