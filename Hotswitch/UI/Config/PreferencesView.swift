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
      Spacer()
      Button("Quit Hotswitch") {
        exit(EXIT_SUCCESS)
      }
    }.frame(maxWidth: .infinity)
      .padding()
  }
}

struct UsagePrefsView : View {
  @State var selectedUsageDays : Int = 5
  var body: some View {
    let stats = UsageData.shared.getUsageStats(daysAgo: selectedUsageDays)
    HStack {
      VStack {
        Table(stats) {
          TableColumn("App", value: \.name)
          TableColumn("Uses") { usage in
            Text(String(usage.count))
          }
        }
        Picker("", selection: $selectedUsageDays) {
          Text("Last 5 days").tag(5)
          Text("Last 14 days").tag(14)
          Text("Alltime").tag(0)
        }
        .padding(.horizontal)
      }
      PieChart(data: stats.map({
        PieData(label: $0.name, value: Double($0.count))
      }))
    }
    .padding()
  }
}
          
struct PurchasePrefsView : View {
  var body: some View {
    Label("PURCHASE", systemImage: "cart")
  }
}

struct PreferencesView: View {
  var close: (() -> ())?
  var selectedIndex = 0
  var body: some View {
    VStack(alignment: .leading) {
      ImageTabView(
        buttonConfig: [ImageTabButtonConfig(caption: "General", systemImageName: "gearshape"),
                       ImageTabButtonConfig(caption: "Usage", systemImageName: "chart.pie"),
                       ImageTabButtonConfig(caption: "Purchase", systemImageName: "cart"),
                       ImageTabButtonConfig(caption: "About", systemImageName: "info.circle")],
        views: [{ AnyView(GeneralPrefsView()) },
                { AnyView(UsagePrefsView())},
                { AnyView(PurchasePrefsView())},
                { AnyView(AboutView())}])
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
    .frame(width: 550, height: 325, alignment: .top)
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
