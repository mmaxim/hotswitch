//
//  Usage.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/10/22.
//

import Foundation

struct AppUsage : Hashable, Identifiable {
  
  var name : String
  var count: Int
  
  var id : String {
    name
  }
}

class UsageData : NSObject {
  
  static let shared = UsageData()

  private func getContext() -> NSManagedObjectContext {
    return PersistenceController.shared.container.viewContext
  }
  
  func appUsed(_ name: String) {
    let context = getContext()
    guard let day = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else {
      print("failed to get day from current date, bailing")
      return
    }
    let usageFetchRequest : NSFetchRequest<Usage> = Usage.fetchRequest()
    let p1 = NSPredicate(format: "appName == %@", name)
    let p2 = NSPredicate(format: "day == %@", day as CVarArg)
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
    usageFetchRequest.predicate = predicate
    
    let results = try? context.fetch(usageFetchRequest)
    var usage: Usage!
    if results?.count == 0 {
      usage = Usage(context: context)
      usage.day = day
      usage.count = 0
      usage.appName = name
    } else {
      usage = results?.first
    }
    usage.count += 1
    
    PersistenceController.shared.save()
  }
  
  func getUsageStats(daysAgo: Int) -> [AppUsage] {
    let context = getContext()
    
    let keypathExp = NSExpression(forKeyPath: "count")
    let expression = NSExpression(forFunction: "sum:", arguments: [keypathExp])

    let countDesc = NSExpressionDescription()
    countDesc.expression = expression
    countDesc.name = "sum"
    countDesc.expressionResultType = .integer64AttributeType
    
    let usageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Usage")
    usageFetchRequest.propertiesToGroupBy = [
      "appName"
    ]
    usageFetchRequest.propertiesToFetch = [
      "appName", countDesc
    ]
    if daysAgo > 0 {
      let daysAgoDate = Calendar.current.date(byAdding: DateComponents(day: -daysAgo), to: Date())
      if daysAgoDate != nil {
        let pred = NSPredicate(format: "day >= %@", daysAgoDate! as CVarArg)
        usageFetchRequest.predicate = pred
      }
    }
    usageFetchRequest.resultType = .dictionaryResultType
    usageFetchRequest.returnsObjectsAsFaults = false
    usageFetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "sum", ascending: false)
    ]
    
    var ret : [AppUsage] = []
    let res = try? context.fetch(usageFetchRequest)
    for row in res ?? [] {
      let dict = row as! NSDictionary
      let appName = dict.value(forKey: "appName") as! String
      let count = dict.value(forKey: "sum") as! Int
      ret.append(AppUsage(name: appName, count: count))
    }
    return ret
  }
}
