//
//  HotKeyGrid.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/7/21.
//

import SwiftUI

struct ActiveConfigSlotIDInfo : Identifiable {
  var slotID: Int
  var id: Int {
    return slotID
  }
}

struct HotKeyGrid: View {
  @EnvironmentObject var hotkeyModel: HotKeyModel
  @State var activeConfigSlotInfo: ActiveConfigSlotIDInfo?
  
  let columns = [
    GridItem(.adaptive(minimum: 120))
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(hotkeyModel.hotKeys, id: \.self) { hotKey in
          Button(action: {
            activeConfigSlotInfo = ActiveConfigSlotIDInfo(slotID: Int(hotKey.slotID))
          } , label: {
            HotKeyView(appName: hotKey.app!, key: hotKey.key, mod: hotKey.mod)
          }).buttonStyle(PlainButtonStyle())
        }
      }
      .padding(.horizontal)
    }
    .padding()
    .frame(width: 600, height: 350)
    .sheet(item: $activeConfigSlotInfo) { item in
      AppConfigView(slotID: item.slotID) {
        activeConfigSlotInfo = nil
      }
    }
  }
}

struct HotKeyGrid_Previews: PreviewProvider {
  static var previews: some View {
    HotKeyGrid()
      .environmentObject(HotKeyModel())
  }
}
