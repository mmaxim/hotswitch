//
//  ImageTabView.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/10/22.
//

import SwiftUI

struct ImageTabViewButton : View {
  @State var hovered = false
  var caption: String
  var systemImageName: String
  var isSelected : Bool
  
  var body: some View {
    VStack(spacing: 1) {
      Image(systemName: systemImageName)
        .resizable()
        .frame(width: 20, height: 20)
      Text(caption)
        .font(.subheadline)
    }
    .foregroundColor(isSelected ? Color(NSColor.selectedContentBackgroundColor) : Color(NSColor.secondaryLabelColor.cgColor))
    .onHover { active in
      hovered = active
    }
    .padding(.top, 10)
    .padding(.bottom, 4)
    .padding(.horizontal, 10)
    .background(hovered ? Color(NSColor.quaternaryLabelColor.cgColor) : Color.clear)
    .cornerRadius(8)
  }
}

private struct ImageTabViewSelectedKey: EnvironmentKey {
  static let defaultValue = 0
}

extension EnvironmentValues {
  var imageTabSelected: Int {
    get { self[ImageTabViewSelectedKey.self] }
    set { self[ImageTabViewSelectedKey.self] = newValue }
  }
}

struct ImageTabButtonConfig : Hashable {
  var caption: String
  var systemImageName: String
}

struct ImageTabView : View  {
  var buttonConfig : [ImageTabButtonConfig]
  var views : [() -> AnyView]
  @State var selectedIndex = 0
  
  init(buttonConfig: [ImageTabButtonConfig], views: [() -> AnyView]) {
    self.buttonConfig = buttonConfig
    self.views = views
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(spacing: 1) {
        ForEach((0...buttonConfig.count-1), id: \.self) { index in
          Button(action: {
            selectedIndex = index
          }, label: {
            ImageTabViewButton(caption: buttonConfig[index].caption, systemImageName: buttonConfig[index].systemImageName, isSelected: selectedIndex == index)
          }).buttonStyle(PlainButtonStyle())
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal)
      Divider()
      views[selectedIndex]()
    }
  }
}

struct TestView : View {
  var body : some View {
    Text("HI")
  }
}

struct ImageTabView_Previews: PreviewProvider {
  static var previews: some View {
    ImageTabView(
      buttonConfig: [ImageTabButtonConfig(caption: "General", systemImageName: "gearshape"),
                     ImageTabButtonConfig(caption: "Usage", systemImageName: "chart.pie"),
                     ImageTabButtonConfig(caption: "Purchase", systemImageName: "cart")],
      views: [ { AnyView(TestView()) },
              { AnyView(Text("USAGE")) },
               { AnyView(Text("PURCHASE")) }])
  }
}
