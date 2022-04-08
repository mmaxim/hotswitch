//
//  AboutView.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/4/22.
//

import SwiftUI

struct AboutView: View {
  var close: () -> ()
  var body: some View {
    VStack(alignment: .trailing){
      HStack(spacing: 24) {
        Image(nsImage: NSApp.applicationIconImage)
          .resizable()
          .frame(width: 128, height: 128)
        VStack(alignment: .leading) {
          Text("App Switcher")
            .font(.title)
          Text("1.0").font(.caption)
          Divider()
            .padding(.bottom, 20)
          Text("Developers")
          Link("Mike Maxim", destination: URL(string: "https://github.com/mmaxim")!)
        }
      }
      Button("Got it!", action: close)
    }
    .padding()
    .frame(minWidth: 400)
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView(close: {})
  }
}
