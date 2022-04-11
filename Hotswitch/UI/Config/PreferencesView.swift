//
//  PreferencesView.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/10/22.
//

import SwiftUI

struct GeneralPrefsView : View {
  @State var startOnLogin = false
  @State var selectedGlobalKey = "Right Option Key"
  var body : some View {
    VStack(spacing: 30) {
      Toggle("Start on login", isOn: $startOnLogin)
      Picker("Global config view key", selection: $selectedGlobalKey) {
        Text("Right Option Key")
        Text("Right Command Key")
        Text("Right Shift Key")
      }
      .frame(width: 300)
    }.frame(maxWidth: .infinity)
      .padding()
  }
}

struct UsagePrefsView : View {
  var body: some View {
    List {
      ForEach(UsageData.shared.getUsageStats(), id: \.self) { usage in
        Text(String(format: "%@: %d", usage.name, usage.count))
      }
    }
  }
}
          
struct PurchasePrefsView : View {
  var body: some View {
    Label("PURCHASE", systemImage: "cart")
  }
}

struct PreferencesView: View {
  var close: (() -> ())?
  var body: some View {
    VStack(alignment: .leading) {
      ImageTabView(
        buttonConfig: [ImageTabButtonConfig(caption: "General", systemImageName: "gearshape"),
                       ImageTabButtonConfig(caption: "Usage", systemImageName: "chart.pie"),
                       ImageTabButtonConfig(caption: "Purchase", systemImageName: "cart")],
        views: [{ AnyView(GeneralPrefsView()) },
                { AnyView(UsagePrefsView())},
                { AnyView(PurchasePrefsView())}])
      .frame(maxHeight: .infinity, alignment: .top)
      VStack(alignment: .leading) {
        Divider()
        Button("Close") {
          if close != nil {
            close!()
          }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 8)
      }
    }
    .frame(width: 450, height: 300, alignment: .top)
    .padding(.top, 8)
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PreferencesView()
      UsagePrefsView().environmentObject(HotKeyModel())
    }
  }
}
