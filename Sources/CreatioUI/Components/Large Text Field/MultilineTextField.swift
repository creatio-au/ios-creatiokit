//
//  MultilineTextField.swift
//  
//
//  Created by Davis Allie on 10/3/2022.
//

import SwiftUI

public struct MultilineTextField: View {
    
    var label: String
    @Binding var text: String
    var colorName: String
    let minimumHeight: CGFloat?
    let includeToolbar: Bool
    
    @State private var height: CGFloat = 28
    @State private var isActive = false
    
    public init(_ label: String, text: Binding<String>, colorName: String, minimumHeight: CGFloat? = nil, includeToolbar: Bool = true) {
        self.label = label
        self._text = text
        self.colorName = colorName
        self.minimumHeight = minimumHeight
        self.includeToolbar = includeToolbar
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text == "" {
                Text(label)
                    .padding(.top, 8)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            
            MultilineTextFieldContent(text: $text, textViewHeight: $height, isActive: $isActive, colorName: colorName, textStyle: .body, includeToolbar: includeToolbar)
                .frame(height: minimumHeight == nil ? height : max(height, minimumHeight!))
        }
        .frame(minHeight: height)
    }
    
}

fileprivate struct MultilineTextFieldContent: UIViewRepresentable {
 
    @Binding var text: String
    @Binding var textViewHeight: CGFloat
    @Binding var isActive: Bool
    var colorName: String
    var textStyle: UIFont.TextStyle
    var includeToolbar: Bool
    
    let keyboardType: UIKeyboardType = .default
    let autocapitilization: UITextAutocapitalizationType = .sentences
    let autocorrect: Bool = true
    let contentType: UITextContentType? = nil
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        //textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.isSelectable = true
        textView.backgroundColor = .clear
        
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.keyboardType = keyboardType
        textView.autocapitalizationType = autocapitilization
        textView.autocorrectionType = autocorrect ? .yes : .no
        textView.textContentType = contentType
        
        textView.delegate = context.coordinator
        
        if includeToolbar {
            let toolbar = UIToolbar()
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            toolbar.items = [
                //UIBarButtonItem(barButtonSystemItem: .trash, target: context.coordinator, action: #selector(context.coordinator.didPressClear(_:))),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.didPressDone(_:)))
            ]
            toolbar.tintColor = .systemBlue
            textView.inputAccessoryView = toolbar
        }
        
        context.coordinator.textView = textView
        
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        context.coordinator.textView = uiView
        context.coordinator.textDidChange = { newText in
            self.text = newText
        }
        
        context.coordinator.heightDidChange = { newHeight in
            self.textViewHeight = newHeight
        }
        
        context.coordinator.activeDidChange = { active in
            self.isActive = active
        }
  
        uiView.text = text
        uiView.textColor = .label
        
        if !context.coordinator.hasSizedInitially {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                uiView.sizeToFit()
                self.textViewHeight = uiView.bounds.height
                context.coordinator.hasSizedInitially = true
            }
        }
        
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
        //uiView.setContentHuggingPriority(.required, for: .vertical)
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
        //uiView.widthAnchor.constraint(equalToConstant: fullWidth).isActive = true
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text, onChange: { newText in
            self.text = newText
        }, onHeightChange: { newHeight in
            self.textViewHeight = newHeight
        }, onActiveChange: { active in
            self.isActive = active
        })
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var textView: UITextView?
        
        var text: String {
            didSet {
                textDidChange(text)
            }
        }

        var textDidChange: ((String) -> Void)
        var heightDidChange: ((CGFloat) -> Void)
        var activeDidChange: ((Bool) -> Void)
        
        var onChangeEnabled = true
        var hasSizedInitially = false
        
        init(_ text: String, onChange: @escaping ((String) -> Void), onHeightChange: @escaping ((CGFloat) -> Void), onActiveChange: @escaping ((Bool) -> Void)) {
            self.text = text
            self.textDidChange = onChange
            self.heightDidChange = onHeightChange
            self.activeDidChange = onActiveChange
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            return true
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            //activeDidChange(true)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            //activeDidChange(false)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            textView.sizeToFit()
            print(textView.bounds.height)
            self.heightDidChange(textView.bounds.height)
        }
        
        @objc func didPressClear(_ sender: UIBarButtonItem) {
            textView?.text = ""
            self.text = ""
            textView?.sizeToFit()
            self.heightDidChange(textView?.bounds.height ?? 38)
        }
        
        @objc func didPressDone(_ sender: UIBarButtonItem) {
            textView?.endEditing(true)
        }
    }
}

