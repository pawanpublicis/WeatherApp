//
//  CustomTextField.swift
//  WeatherApp
//
//  Created by Pawan on 26/06/24.
//

import SwiftUI
import UIKit

class UIKitTextFieldWrapper: UITextField {
	override var inputAssistantItem: UITextInputAssistantItem {
		let item = UITextInputAssistantItem()
		item.leadingBarButtonGroups = []
		item.trailingBarButtonGroups = []
		return item
	}
}

struct CustomTextField: UIViewRepresentable {
	@Binding var text: String
	var placeholder: String
	
	func makeUIView(context: Context) -> UIKitTextFieldWrapper {
		let textField = UIKitTextFieldWrapper()
		textField.placeholder = placeholder
		textField.text = text
		textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
		textField.delegate = context.coordinator
		return textField
	}
	
	func updateUIView(_ uiView: UIKitTextFieldWrapper, context: Context) {
		uiView.text = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(text: $text)
	}
	
	class Coordinator: NSObject, UITextFieldDelegate {
		@Binding var text: String
		
		init(text: Binding<String>) {
			_text = text
		}
		
		func textFieldDidChangeSelection(_ textField: UITextField) {
			text = textField.text ?? ""
		}
	}
}
