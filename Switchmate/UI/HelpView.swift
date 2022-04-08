//
//  HelpView.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/6/22.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
      VStack(spacing: 50) {
        Text("App Switcher allows users to assign system wide hot keys to bring their favorite apps to focus. Click the app icons in the grid to configure that slot with an app and a hot key.")
        Image("help-grid")
      }.frame(maxWidth: 400)
        .padding()
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
        .frame(width: 400, height: 400)
    }
}
