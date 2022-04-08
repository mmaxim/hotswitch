//
//  PersistenceController.swift
//  ZbChat
//
//  Created by Mike Maxim on 3/19/21.
//

import Foundation
import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "Config")
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func save() {
    let context = container.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
      }
    }
  }
}
