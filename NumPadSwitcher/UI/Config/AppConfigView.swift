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
    let currentApp = apphelper.getAppByName(name: model.hotKeys[slotID].app ?? "<unknown>")
    VStack(alignment: .leading) {
      HStack {
        Text("Running applications")
        TextFieldDebounced(title: "Filter", text: $filter)
          .frame(maxWidth: 250, alignment: .trailing)
      }
      List {
        ForEach(applyFilter(), id: \.self.name) { rapp in
          AppDescView(rapp: rapp)
        }
      }.frame(width: 500, height: 200)
      Divider()
      Text("Currently selected")
      if (currentApp != nil) {
        AppDescView(rapp: currentApp!)
      } else {
        Text(model.hotKeys[slotID].app ?? "<no app selected>").padding(.vertical)
      }
      HStack {
        Button("Save") {}
        Button("Cancel") {}
      }
    }.padding()
  }
}

struct AppConfigView_Previews: PreviewProvider {
  static var previews: some View {
    AppConfigView(slotID: 0).environmentObject(HotKeyModel())
  }
}
