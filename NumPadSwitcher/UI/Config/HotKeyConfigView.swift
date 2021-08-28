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
    hotkeyMonitor = NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: { (event) -> NSEvent? in
      let slot = model.getSlot(slotID)
      slot.key = Int32(event.keyCode)
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
    VStack(alignment: .leading, spacing: 40) {
      HStack {
        Text("Hot Key: ")
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
            Text(HotKeyConverter.keyCode(toString: UInt32(model.getSlot(slotID).key)))
              .frame(width: 100)
          }
        })
      }
      HStack {
        Button("Save") {
          model.persist()
        }
        Button("Cancel") {
          model.revert()
        }
      }
    }
    .frame(height: 100)
    .padding()
  }
}

struct HotKeyConfigView_Previews: PreviewProvider {
  static var previews: some View {
    HotKeyConfigView(slotID: 0).environmentObject(HotKeyModel())
  }
}
