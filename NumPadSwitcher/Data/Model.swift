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
  let maxSlots = 10
  
  override init() {
    super.init()
    load()
  }
  
  func load() {
    let context = PersistenceController.shared.container.viewContext
    let hotkeyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HotKey")
    hotkeyFetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \HotKey.slotID, ascending: true)
    ]
    self.hotKeys = try! context.fetch(hotkeyFetchRequest) as! [HotKey]
    
    if self.hotKeys.count < maxSlots {
      for slotID in 0...(maxSlots - self.hotKeys.count - 1) {
        newEmptySlot(slotID)
      }
    }
  }
  
  func newEmptySlot(_ slotID: Int) {
    let context = PersistenceController.shared.container.viewContext
    let hotKey = HotKey(context: context)
    hotKey.app = "<none>"
    hotKey.key = 0
    hotKey.mod = 0
    hotKey.slotID = Int32(slotID)
    hotKeys.append(hotKey)
    persist()
  }
  
  func getSlot(_ slotID: Int) -> HotKey {
    return hotKeys[slotID]
  }
  
  func persist() {
    PersistenceController.shared.save()
    self.objectWillChange.send()
  }
  func revert() {
    PersistenceController.shared.container.viewContext.rollback()
    load()
  }
}
