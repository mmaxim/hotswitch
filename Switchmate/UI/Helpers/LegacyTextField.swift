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
  var isFirstResponder = false
  
  public func makeNSView(context: Context) -> NSTextField {
    let view = NSTextField()
    view.delegate = context.coordinator
    return view
  }
  
  public func updateNSView(_ view: NSTextField, context: Context) {
    view.stringValue = text
    switch context.coordinator.isFirstResponder {
    case true: view.becomeFirstResponder()
    case false: view.resignFirstResponder()
    }
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator($text, isFirstResponder)
  }
  
  public class Coordinator: NSObject, NSTextFieldDelegate {
    var text: Binding<String>
    var isFirstResponder: Bool
    
    init(_ text: Binding<String>, _ isFirstResponder: Bool) {
      self.text = text
      self.isFirstResponder = isFirstResponder
    }
    
    func controlTextDidChange(_ obj: Notification) {
      let textField = obj.object as! NSTextField
      self.text.wrappedValue = textField.stringValue
      self.isFirstResponder = false
    }
  }
}
