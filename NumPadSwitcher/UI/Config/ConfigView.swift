//
//  ConfigView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import SwiftUI

struct ConfigView: View {
  @State var currentTab = 0
  var slotID: Int
  
  var body: some View {
    TabView(selection: $currentTab) {
      AppConfigView(slotID: slotID)
        .tag(0)
        .tabItem { Text("App") }
      HotKeyConfigView(slotID: slotID)
        .tag(0)
        .tabItem { Text("Hot Key") }
    }
  }
}

struct ConfigView_Previews: PreviewProvider {
  static var previews: some View {
    ConfigView(slotID: 0).environmentObject(HotKeyModel())
  }
}
