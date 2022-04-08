//
//  RootView.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/5/22.
//

import SwiftUI

struct RootView: View {
  @State var configSlotID = -1
  @State var showingAboutView = false
  @State var showConfigureHelp = false
  @State var showHotkeyHelp = false
  
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
        
        Menu {
          Button("About", action: {
            showingAboutView = true
          })
          Button(action: {
            NSApp.terminate(nil)
          }) {
            Label("Quit", systemImage: "")
          }
        } label: {
          Image(systemName: "gearshape")
        }
        .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: true))
        .padding(.horizontal)
        .fixedSize()
        .frame(maxWidth: .infinity, alignment: .trailing)
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
    .sheet(isPresented: $showingAboutView) {
      AboutView() {
        showingAboutView.toggle()
      }
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView().environmentObject(HotKeyModel())
  }
}
