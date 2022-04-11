//
//  Usage.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/10/22.
//

import Foundation

struct AppUsage : Hashable {
  var name : String
  var count: Int
}

class UsageData : NSObject {
  
  static let shared = UsageData()

  private func getContext() -> NSManagedObjectContext {
    return PersistenceController.shared.container.viewContext
  }
  
  func appUsed(_ name: String) {
    let context = getContext()
    let usage = Usage(context: context)
    usage.appName = name
    usage.time = Date()
    PersistenceController.shared.save()
  }
  
  func getUsageStats() -> [AppUsage] {
    let context = getContext()
    
    let keypathExp = NSExpression(forKeyPath: "appName")
    let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])

    let countDesc = NSExpressionDescription()
    countDesc.expression = expression
    countDesc.name = "count"
    countDesc.expressionResultType = .integer64AttributeType
    
    let usageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Usage")
    usageFetchRequest.propertiesToGroupBy = [
      "appName"
    ]
    usageFetchRequest.propertiesToFetch = [
      "appName", countDesc
    ]
    usageFetchRequest.resultType = .dictionaryResultType
    usageFetchRequest.returnsObjectsAsFaults = false
    
    var ret : [AppUsage] = []
    let res = try! context.fetch(usageFetchRequest)
    for row in res {
      let dict = row as! NSDictionary
      let appName = dict.value(forKey: "appName") as! String
      let count = dict.value(forKey: "count") as! Int
      ret.append(AppUsage(name: appName, count: count))
    }
    return ret
  }
}
