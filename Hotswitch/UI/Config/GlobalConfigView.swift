//
//  GlobalConfigView.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/9/22.
//

import SwiftUI

struct GlobalConfigView: View {
  var body: some View {
    HotKeyGrid(slotID: Binding.constant(0))
      .frame(maxWidth: .infinity)
      .background(Color.clear)
      .foregroundColor(Color.white)
  }
}

struct GlobalConfigView_Previews: PreviewProvider {
  static var previews: some View {
    GlobalConfigView()
  }
}

