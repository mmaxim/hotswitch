//
//  RootView.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/5/22.
//

import SwiftUI

struct RootView: View {
  @State var configSlotID = -1
  @State var showingPreferencesSheet = false
  @State var showConfigureHelp = false
  @State var showHotkeyHelp = false
  let popoverPub = NotificationCenter.default.publisher(for: .popoverClosed)
  
  var body: some View {
    let onHotkeyGrid = configSlotID < 0
    VStack {
      HStack {
        Text((onHotkeyGrid) ? "Configure hot keys" : "Select app and hot key")
          .font(.title3)
          .frame(alignment: .leading)
          .padding()
        Button(action: {
          if onHotkeyGrid {
            showConfigureHelp.toggle()
          } else {
            showHotkeyHelp.toggle()
          }
        }, label: {
          Image(systemName: "questionmark.circle")
        }).buttonStyle(PlainButtonStyle())
          .popover(isPresented: $showConfigureHelp) {
            Text("Click an app icon in the grid below to configure an app and hot key configuration.")
              .fixedSize(horizontal: false, vertical: true)
              .frame(width: 200, height: 75)
              .padding()
          }
          .popover(isPresented: $showHotkeyHelp) {
            Text("Select an app from the list, and then hit the \"Set hotkey\" button below. When it says \"Recording\", enter your desired hot key. Modifiers such as ⌘ are supported.")
              .fixedSize(horizontal: false, vertical: true)
              .frame(width: 200, height: 150)
              .padding()
          }
        
        Button(action: {
          showingPreferencesSheet = true
        }, label: {
          Image(systemName: "gearshape")
        }).buttonStyle(PlainButtonStyle())
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.horizontal)
      }
      .background(Color(NSColor.controlBackgroundColor))
      .frame(maxWidth: .infinity)
      if onHotkeyGrid {
        HotKeyGrid(slotID: $configSlotID)
      } else {
        AppConfigView(slotID: configSlotID, close: {
          configSlotID = -1
        })
      }
    }
    .sheet(isPresented: $showingPreferencesSheet) {
      PreferencesView() {
        showingPreferencesSheet.toggle()
      }
    }.onReceive(popoverPub) { _ in
      showingPreferencesSheet = false
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView().environmentObject(HotKeyModel())
  }
}
