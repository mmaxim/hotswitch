//
//  AppHelper.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import Foundation
import Cocoa

struct AppDesc : Equatable {
  var name: String
  var icon: NSImage?
  var bigIcon: NSImage?
  
  static func == (lhs: AppDesc, rhs: AppDesc) -> Bool {
    return lhs.name == rhs.name
  }
}

class AppHelper {
  public static let shared = AppHelper()
  
  public func getRunningApps() -> [AppDesc] {
    let apps = NSWorkspace.shared.runningApplications
    var ret : [AppDesc] = []
    for app in apps {
      let bigIcon = app.icon?.copy() as! NSImage?
      bigIcon?.size = NSMakeSize(64,64)
      ret.append(AppDesc(name: app.localizedName ?? "<unknown>", icon: app.icon, bigIcon: bigIcon))
    }
    ret.sort { return $0.name < $1.name }
    return ret
  }
  
  public func getAppByName(name: String) -> AppDesc? {
    for app in getRunningApps() {
      if (app.name == name) {
        return app
      }
    }
    return nil
  }
  
  private init() {}
}

