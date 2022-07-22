//
//  InputTextField.swift
//  Lomi
//
//  Created by Takayuki Yamaguchi on 2021-12-15.
//

import Foundation
import SwiftUI

/// The input component for the Lomi app. Style will change based on inputType.
struct InputTextField: View {
    
    @Binding var field: String
    @State var isSecure: Bool = false
    var inputType: InputType
    var prompt: String = ""
    /// Custom validation icon displayed when it is valid. Default is checkmark.
    var validIcon: String? = "checkmark"
    var showEyeIcon: Bool = false
    
    /// This is an actual prompt for displaying. We don't always want to update and display prompt every time users type, e.g, updating only un-focus. We can update this variable at arbitrary timing.
    @State private var promptDisplay: String = ""
    /// Responsible for when to start first validation. As long as this is `true`, we don't update UI.  This gets `false` after unfocusing text field.
    @State private var isFirstValidation: Bool = true
    /// Responsible for if the text field is focused or not
    @State private var isFirstResponder: Bool = false
    /// Responsible for when to update UI. Note;`True` doesn't always mean the actual field is valid. We can update this variable at arbitrary timing.
    @State private var isValid: Bool = false
    
    /// Responsible for when to display placeholder instead of label+field
    private var isPlaceholder: Bool {
        !isFirstResponder && field.isEmpty
    }
    /// Responsible for any animation effect in this text field.
    private var animation: Animation {
        .easeInOut(duration: 0.24)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(inputType.rawValue)
                        .foregroundColor(.textGreyInactive)
                        .animatableSystemFontSize(isPlaceholder ? 16 : 12)
                        .accessibilityHidden(!isPlaceholder)
                        .accessibilityLabel("\(inputType.rawValue) form")
                        .accessibilityIdentifier("\(inputType.rawValue)_LABEL".identifierFormat())
                    
                    if !isPlaceholder {
                        textField
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, isPlaceholder ? 0 : 4)
                
                Spacer()
                statusIcon
            }
            .frame(height: 52)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Color.inputFieldsOffWhite)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isValid || isFirstValidation ? Color.clear : Color.alert , lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(animation) {
                    isFirstResponder = true
                }
            }
            /*
             - Detect only **unfocus**
                - update first validation flag
                - update prompt
                - update validation
             */
            .onChange(of: isFirstResponder) { isFirstResponder in
                if isFirstResponder { return }
                
                withAnimation(animation) {
                    isFirstValidation = false
                    promptDisplay = prompt
                    isValid = prompt.isEmpty
                }
            }
            /*
             - Detect prompt change (if not "only unfocus" type, e.g, email)
                - update validation
                - update prompt
             */
            .onChange(of: prompt) { newPrompt in
                if inputType.shouldValidateOnlyUnfocus() { return }
                
                withAnimation(animation) {
                    isValid = newPrompt.isEmpty
                    promptDisplay = newPrompt
                }
            }
            
            Text(promptDisplay)
                .foregroundColor(.alert)
                .font(.caption2)
                .italic()
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
                .display(!isValid && !isFirstValidation)
                .accessibilityLabel("\(inputType.rawValue) is invalid. \(prompt)")
        }
    }
}


// MARK: - Subviews
private extension InputTextField {
    @ViewBuilder
    var textField: some View {
        UIKitTextField(text: $field, isFirstResponder: $isFirstResponder, responderAnimation: animation) { uiTextField in
            uiTextField.isSecureTextEntry = isSecure
            uiTextField.textColor = isSecure ? UIColor(.textGreyInactive) : UIColor(.primarySoftBlack)
            uiTextField.setupStyle(inputType)
        }
        .background(Color.clear)
        .foregroundColor(.black)
        .frame(height: 24)
        .accessibilityLabel(inputType.rawValue)
        .accessibilityIdentifier("\(inputType.rawValue)_TEXT_FIELD".identifierFormat())
    }
    
    var statusIcon: some View {
        HStack(alignment: .center, spacing: 8) {
            if let iconName = validIcon {
                Image(systemName: iconName)
                    .foregroundColor(isValid && !isFirstValidation ? .successGreen : .clear)
                    .font(.system(size: 13, weight: .bold))
                    .rotationEffect(.degrees(10))
                    .accessibilityRemoveTraits(.isImage)
                    .accessibilityLabel(isValid ? "\(inputType.rawValue) is Valid" : "\(inputType.rawValue) is invalid. \(prompt)")
                    .accessibilityHidden(isPlaceholder)
            }
            
            Button {
                withAnimation(animation) {
                    isSecure.toggle()
                    if !isFirstResponder  {
                        isFirstResponder = true
                    }
                }
            } label: {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.textGreyInactive)
                    .font(.system(size: 12, weight: .regular))
            }
            .accessibilityLabel(isSecure ? "Show Password" : "Hide Password")
            .display(showEyeIcon)
        }
        .padding(.trailing, 8)
    }
}


// MARK: - Previews
extension InputTextField {
    /// This init is only used for previewing. We can also set private @State vars.
    fileprivate init(
        field: Binding<String>,
        isSecure: Bool = false,
        inputType: InputType,
        prompt: String = "",
        validIcon: String? = "checkmark",
        showEyeIcon: Bool = false,
        promptDisplay: String = "",
        isFirstValidation: Bool = true,
        isFirstResponder: Bool = false,
        isValid: Bool = false
    ) {
        self._field = field
        self._isSecure = State(initialValue: isSecure)
        self.inputType = inputType
        self.prompt = prompt
        self.validIcon = validIcon
        self.showEyeIcon = showEyeIcon
        self._promptDisplay = State(initialValue: promptDisplay)
        self._isFirstValidation = State(initialValue: isFirstValidation)
        self._isFirstResponder = State(initialValue: isFirstResponder)
        self._isValid = State(initialValue: isValid)
    }
}


struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.clear
                .frame(height:300)
            InputTextField(
                field: Binding.constant("first name with focus"),
                inputType: .firstName,
                isFirstResponder: true
            )
            InputTextField(
                field: Binding.constant("last name with valid"),
                inputType: .lastName,
                isFirstValidation: false,
                isValid: true
            )
            InputTextField(
                field: Binding.constant(""),
                inputType: .email
            )
            InputTextField(
                field: Binding.constant("invalid email"),
                inputType: .email,
                promptDisplay: "PromptDisplay. When the field is invalid and after users unfocus, this message will be displayed",
                isFirstValidation: false,
                isValid: false
            )
            InputTextField(
                field: Binding.constant("Password with secured. This is a bit bug and the field won't be displayed at the preview"),
                isSecure: true,
                inputType: .password,
                showEyeIcon: true
            )
            InputTextField(
                field: Binding.constant("Password with not-secured"),
                isSecure: false,
                inputType: .confirmationPassword,
                showEyeIcon: true
            )
            InputTextField(
                field: Binding.constant("device nickname"),
                inputType: .deviceNickname
            )
            InputTextField(
                field: Binding.constant("L10222000000"),
                inputType: .deviceSerialNumber
            )
        }
        .padding()
    }
}
