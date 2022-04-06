//
//  LegacyTextField.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/6/22.
//

import SwiftUI
import AppKit

struct LegacyTextField: NSViewRepresentable {
  
  @Binding var text: String
  @Binding public var isFirstResponder: Bool
  
  public func makeNSView(context: Context) -> NSTextField {
    let view = NSTextField()
    view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    view.delegate = context.coordinator
    return view
  }
  
  public func updateNSView(_ view: NSTextField, context: Context) {
    view.stringValue = text
    switch isFirstResponder {
    case true: view.becomeFirstResponder()
    case false: view.resignFirstResponder()
    }
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator($text, isFirstResponder: $isFirstResponder)
  }
  
  public class Coordinator: NSObject, NSTextFieldDelegate {
    var text: Binding<String>
    var isFirstResponder: Binding<Bool>
    
    init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
      self.text = text
      self.isFirstResponder = isFirstResponder
    }
    
    public func controlTextDidChange(_ obj: Notification) {
      let textField = obj.object as! NSTextField
      self.text.wrappedValue = textField.stringValue
      self.isFirstResponder.wrappedValue = false
    }
    
   
  }
}
