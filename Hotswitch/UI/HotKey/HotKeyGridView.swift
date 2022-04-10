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
  @Binding var slotID : Int
  @EnvironmentObject var hotkeyModel: HotKeyModel
  
  let columns = [
    GridItem(.adaptive(minimum: 120))
  ]
  
  var body: some View {
    VStack(spacing: 0) {
      LazyVGrid(columns: columns) {
        ForEach(hotkeyModel.hotKeys, id: \.self) { hotKey in
          Button(action: {
            slotID = Int(hotKey.slotID)
          } , label: {
            HotKeyView(appName: hotKey.app!, key: hotKey.key, mod: hotKey.mod)
          }).buttonStyle(PlainButtonStyle())
        }
      }
    }
    .frame(maxHeight: .infinity)
    .background(Color.clear)
  }
}


struct HotKeyGrid_Previews: PreviewProvider {
  static var previews: some View {
    HotKeyGrid(slotID: Binding.constant(0))
      .environmentObject(HotKeyModel())
      .frame(width: 600, height: 450)
  }
}

