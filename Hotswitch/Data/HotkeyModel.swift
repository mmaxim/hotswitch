//
//  Model.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/26/21.
//

import Foundation
import CoreData

class HotKeyModel : NSObject, ObservableObject {
  @Published var hotKeys : [HotKey]!
  let maxSlots = 12
  
  override init() {
    super.init()
    load()
  }
  
  func load() {
    let context = PersistenceController.shared.container.viewContext
    let hotkeyFetchRequest : NSFetchRequest<HotKey> = HotKey.fetchRequest()
    hotkeyFetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \HotKey.slotID, ascending: true)
    ]
    self.hotKeys = try? context.fetch(hotkeyFetchRequest)
    
    // make empty slots to get up to desired number of slots
    let sz = self.hotKeys.count
    if sz < maxSlots {
      for _ in 0...(maxSlots - sz - 1) {
        newEmptySlot()
      }
    }
  }
  
  func newEmptySlot() {
    let context = PersistenceController.shared.container.viewContext
    let hotKey = HotKey(context: context)
    hotKey.app = ""
    hotKey.key = -1
    hotKey.mod = -1
    hotKey.slotID = Int32(hotKeys.count)
    hotKeys.append(hotKey)
    persist()
  }
  
  func isSlotConfigured(_ slotID: Int) -> Bool {
    let slot = hotKeys[slotID]
    if (slot.app?.isEmpty ?? true) {
      return slot.key < 0;
    }
    return slot.key >= 0
  }
  
  func getSlot(_ slotID: Int) -> HotKey {
    return hotKeys[slotID]
  }
  
  func resetSlot(_ slotID: Int) {
    let slot = hotKeys[slotID]
    slot.app = ""
    slot.key = -1
    slot.mod = -1
    self.objectWillChange.send()
  }
  
  func assignAppToSlot(_ slotID: Int, app: String) {
    let slot = hotKeys[slotID]
    slot.app = app
    self.objectWillChange.send()
  }
  
  func assignKeyToSlot(_ slotID: Int, key: Int32, mod: Int32) {
    let slot = hotKeys[slotID]
    slot.key = key
    slot.mod = mod
    self.objectWillChange.send()
  }
  
  func getHotKeysForBridge() -> [HotKeyBridge] {
    var ret : [HotKeyBridge] = []
    for hotKey in hotKeys {
      let hkb = HotKeyBridge()!
      hkb.appName = hotKey.app
      hkb.keyCode = hotKey.key
      hkb.mod = hotKey.mod
      ret.append(hkb)
    }
    return ret
  }
  
  func persist() {
    PersistenceController.shared.save()
    self.objectWillChange.send()
  }
  func revert() {
    PersistenceController.shared.container.viewContext.rollback()
    load()
  }
  func hasChanges() -> Bool {
    return PersistenceController.shared.container.viewContext.hasChanges
  }
}
