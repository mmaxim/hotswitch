//
//  HotKeyView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/7/21.
//

import SwiftUI

struct HotKeyView: View {
  var app: String?
  var key: String?
  var mod: String?
  
  var body: some View {
    VStack {
      Text(app ?? "<no app set>")
      Spacer().frame(height: 20)
      if key != nil {
        if mod == nil {
          Text(key!)
        } else {
          Text(String(format:"%@ + %@", mod!, key!))
        }
      } else {
        Text("<no hotkey set>")
      }
    }.frame(width: 200, height: 100)
  }
  
}

struct HotKeyView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HotKeyView(app: "Keybase", key: "Numpad+0")
      HotKeyView(app: "Google Chrome", key: "K", mod: "Alt")
      HotKeyView(app: "zoom.us")
      HotKeyView()
    }
  }
}
