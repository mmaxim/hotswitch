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
  @State var showingAboutView = false
  var aboutModal = ModalController(width: 400, height: 200, content: { AboutView(){}})
  
  let columns = [
    GridItem(.adaptive(minimum: 120))
  ]
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("App Switcher")
          .italic()
          .font(.largeTitle)
          .frame(alignment: .leading)
          .padding()
        
        Menu {
          Button("Help", action: {
            NSApp.terminate(nil)
          })
          Button("About", action: {
            showingAboutView = true
          })
          Divider()
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
      .frame(maxWidth: .infinity)
      Divider()
      LazyVGrid(columns: columns) {
        ForEach(hotkeyModel.hotKeys, id: \.self) { hotKey in
          Button(action: {
            activeConfigSlotInfo = ActiveConfigSlotIDInfo(slotID: Int(hotKey.slotID))
          } , label: {
            HotKeyView(appName: hotKey.app!, key: hotKey.key, mod: hotKey.mod)
          }).buttonStyle(PlainButtonStyle())
        }
      }
      .frame(width: 600, height: 370)
      .sheet(item: $activeConfigSlotInfo) { item in
        AppConfigView(slotID: item.slotID) {
          activeConfigSlotInfo = nil
        }
      }
      .sheet(isPresented: $showingAboutView) {
        AboutView() {
          showingAboutView.toggle()
        }
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
