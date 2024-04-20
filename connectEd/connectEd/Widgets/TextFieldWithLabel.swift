//
//  TextFieldWithLabel.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI

struct TextFieldWithLabel: View {
  var label: String
  var placeholder : String?
  var hint: String?
  @Binding var text: String

  var validationStatus: Binding<Bool>?
  var validationMessage: String?
  var validator: (() -> Bool)?

  var body: some View {
    VStack(alignment: .leading, spacing: 3.0) {
      HStack {
        Text(label).font(.caption).bold()
        Spacer()
        if let hint = hint {
          Text(hint).font(.caption2)
        }
      }
      TextField(placeholder ?? "", text: $text)
        .onChange(of: text) {
          if let validator { validationStatus?.wrappedValue = validator() }
        }
        .padding()
         .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(
          self.validationStatus?.wrappedValue == false ? Color.red :
          Color.black, style: StrokeStyle(lineWidth: 1.0)))
         .padding()

      if let validationMessage = validationMessage, validationStatus?.wrappedValue == false {
        Text(validationMessage).foregroundColor(.red).font(.caption)
      }
    }
  }
}

struct TextFieldWithLabelAlt: View {
  let label: String
  @Binding var text: String
  var prompt: String? = nil

  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
        .modifier(FormLabel())
      TextField(label, text: $text, prompt: promptText())
        .padding(.bottom, 20)
    }
  }

  func promptText() -> Text? {
    if let prompt {
      return Text(prompt)
    } else {
      return nil
    }
  }
}

struct FormLabel: ViewModifier {
  func body(content: Content) -> some View {
    content
      .bold()
      .font(.caption)
  }
}

struct TextFieldWithLabel_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldWithLabel(label: "Text Label", placeholder: "Placeholder", hint: "This is a hint.", text: Binding.constant("CS290.02"))
      .padding(10)
  }
}
