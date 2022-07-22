//
//  UIKitTextField.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2022-03-22.
//

import SwiftUI

/// A view which wraps `UITextField`. The internal `Coordinator` class conforms to the `UITextFieldDelegate` so that we can use those delgate methods.
///  [Inspiration ](https://stackoverflow.com/questions/56507839/swiftui-how-to-make-textfield-become-first-responder)
struct UIKitTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String
    
    /// This config is executed whenever the view is updated
    public var configuration = { (view: UITextField) in }
    
    /// Initilizer
    /// - Parameters:
    ///   - text: The text that the text field displays.
    ///   - isFirstResponder: `FirstResponder` state (`Bool`)  of this TextField
    ///   - responderAnimation: Animation for whenever `isFirstResponder` is updated. You can disable it with passing `nil`
    ///   - configuration: Configuration for UITextField. This config is executed whenever the view is updated
    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, responderAnimation: Animation? = .default,  configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder.animation(responderAnimation)
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        // This will prevent expanding view when we type a lot characters. == This makes the content eaily compress horizontally.
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        DispatchQueue.main.async {
            uiView.text = text
            configuration(uiView)
            switch isFirstResponder {
            case true: uiView.becomeFirstResponder()
            case false: uiView.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>
        
        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }
        
        /// Updating text
        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }
        
        /// Become FirstResponder if begin editing
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }
        
        /// Resign FirstResponder if end editing
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
        
        /// Resign FirstResponder if enter return
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.isFirstResponder.wrappedValue = false
            return true
        }
    }
}
