//
//  HotKeyView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/7/21.
//

import SwiftUI

struct HotKeyView: View {
  var appName: String
  var key: Int32?
  var mod: Int32?
  
  @ViewBuilder
  var body: some View {
    VStack {
      if appName.isEmpty {
        Image("no-app")
          .resizable()
          .frame(width: 64, height: 64)
      } else {
        let app = AppHelper.shared.getAppByName(name: appName)
        if app != nil {
          if (app!.bigIcon != nil) {
            Image(nsImage: app!.bigIcon!)
          }
          Text(app!.name)
        } else {
          Image("no-app")
            .resizable()
            .frame(width: 64, height: 64)
          Text(appName)
        }
        let keyBind = HotKeyConverter.keyCode(toString: key!, andMod: mod ?? 0)
        if keyBind != nil {
          Text(keyBind!)
        }
      }
    }.frame(minHeight: 100, alignment: .topLeading)
  }
}

struct HotKeyView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HotKeyView(appName: "Keybase", key: 5, mod: nil)
      HotKeyView(appName: "", key: 5, mod: nil)
      HotKeyView(appName: "XXX", key: 5, mod: nil)
    }
  }
}
