//
//  HotKeyConfigView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import SwiftUI

struct HotKeyConfigView: View {
  @EnvironmentObject var model: HotKeyModel
  @State var recording = false
  var slotID: Int
  @State var hotkeyMonitor: Any?
  
  func listenForHotKey() {
    recording = true
    hotkeyMonitor = NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown,
                                                     handler: { (event) -> NSEvent? in
      model.assignKeyToSlot(slotID, key: Int32(event.keyCode),
                            mod: HotKeyConverter.nsEventMod(toCarbon: Int32(event.modifierFlags.rawValue)))
      stopListenForHotKey()
      return nil;
    });
  }
  
  func stopListenForHotKey() {
    if (hotkeyMonitor != nil) {
      NSEvent.removeMonitor(hotkeyMonitor!)
    }
    recording = false
  }
  
  var body: some View {
    HStack(spacing: 30) {
      Button(action: {
        recording.toggle()
        if (recording) {
          listenForHotKey()
        } else {
          stopListenForHotKey()
        }
      }, label: {
        if (recording) {
          Text("Recording...")
            .frame(width: 100)
        } else {
          Text(HotKeyConverter.keyCode(toString: model.getSlot(slotID).key,
                                       andMod: model.getSlot(slotID).mod) ?? "Set hotkey")
            .frame(width: 100)
        }
      })
    }
  }
}

struct HotKeyConfigView_Previews: PreviewProvider {
  static var previews: some View {
    HotKeyConfigView(slotID: 0).environmentObject(HotKeyModel())
  }
}
