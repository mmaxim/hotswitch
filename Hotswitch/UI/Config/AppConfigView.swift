//
//  AppConfigView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import SwiftUI

struct AppDescView : View {
  var rapp: AppDesc
  var isSelected: Bool
  
  var body: some View {
    HStack {
      if (rapp.icon != nil) {
        Image(nsImage: rapp.icon!)
      }
      Text(rapp.name)
        .foregroundColor((isSelected) ? Color.white : Color.primary)
    }
  }
}

struct AppConfigView: View {
  @EnvironmentObject var model: HotKeyModel
  var slotID: Int
  @State var filter = ""
  @State var selectedApp: AppDesc?
  var close : () -> ()
  
  func applyFilter() -> [AppDesc] {
    let runningApps = AppHelper.shared.getRunningApps()
    if filter.isEmpty {
      return runningApps
    }
    var res: [AppDesc] = []
    for app in runningApps {
      if app.name.lowercased().contains(filter.lowercased()) {
        res.append(app)
      }
    }
    return res
  }
  
  @ViewBuilder
  var body: some View {
    let apphelper = AppHelper.shared
    let currentApp = apphelper.getAppByName(name: model.getSlot(slotID).app ?? "<unknown>")
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("Running applications")
        TextFieldDebounced(title: "Filter", text: $filter)
          .frame(maxWidth: 250, alignment: .trailing)
      }
      List {
        ForEach(applyFilter(), id: \.self.name) { rapp in
          let isSelected = selectedApp != nil && rapp == selectedApp
          Button(action: {
            selectedApp = rapp
            model.assignAppToSlot(slotID, app: rapp.name)
          }, label: {
            AppDescView(rapp: rapp, isSelected: isSelected)
              .frame(maxWidth: .infinity, alignment: .leading)
          })
          .buttonStyle(BorderlessButtonStyle())
          .padding(.horizontal, 2)
          .padding([.top, .bottom], 2)
          .listRowBackground((isSelected) ? Color(NSColor.selectedContentBackgroundColor) : Color(NSColor.controlBackgroundColor))
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      Divider()
      HStack {
        if (currentApp != nil) {
          AppDescView(rapp: currentApp!, isSelected: false)
        } else {
          Text(model.getSlot(slotID).app ?? "<no app selected>").padding(.vertical)
        }
        if (currentApp != nil) {
          HotKeyConfigView(slotID: slotID)
        }
      }
      Divider()
      HStack {
        Button("Save") {
          model.persist()
          HotKeysRegistrar.shared().syncHotKeys(model.getHotKeysForBridge())
          close()
        }.disabled(!model.isSlotConfigured(slotID) || !model.hasChanges())
        Button("Cancel") {
          model.revert()
          close()
        }
        Button("Reset") {
          model.resetSlot(slotID)
        }
      }
    }
    .padding()
  }
}

struct AppConfigView_Previews: PreviewProvider {
  static var previews: some View {
    AppConfigView(slotID: 0, selectedApp: AppDesc(name: "Activity Monitor", inDock: true),
                  close: {}).environmentObject(HotKeyModel())
  }
}
