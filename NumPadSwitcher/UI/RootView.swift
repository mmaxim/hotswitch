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
  
  var body: some View {
    VStack {
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
      if configSlotID < 0 {
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
