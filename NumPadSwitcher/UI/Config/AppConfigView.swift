//
//  AppConfigView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import SwiftUI

struct AppDescView : View {
  var rapp: AppDesc
  var body: some View {
    HStack {
      if (rapp.icon != nil) {
        Image(nsImage: rapp.icon!)
      }
      Text(rapp.name)
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
          AppDescView(rapp: rapp)
            .listRowBackground((selectedApp != nil && rapp == selectedApp) ? Color(NSColor.selectedContentBackgroundColor) : Color(NSColor.windowBackgroundColor))
            .onTapGesture {
              selectedApp = rapp
              model.assignAppToSlot(slotID, app: rapp.name)
            }
        }
      }.frame(width: 500, height: 200)
      Divider()
      HStack {
        if (currentApp != nil) {
          AppDescView(rapp: currentApp!)
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
    }.padding()
  }
}

struct AppConfigView_Previews: PreviewProvider {
  static var previews: some View {
    AppConfigView(slotID: 0, close: {}).environmentObject(HotKeyModel())
  }
}
