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
  
  var body: some View {
    VStack {
      Text(app ?? "<click to set>")
      Spacer().frame(height: 20)
      if key != nil {
        Text(key!)
      }
    }.frame(width: 200, height: 100)
  }
  
}

struct HotKeyView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HotKeyView(app: "Keybase", key: "Numpad+0")
      HotKeyView(app: "Google Chrome", key: "K")
      HotKeyView(app: "zoom.us")
      HotKeyView()
    }
  }
}
