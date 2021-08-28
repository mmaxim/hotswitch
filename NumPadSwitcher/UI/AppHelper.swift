//
//  AppHelper.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import Foundation
import Cocoa

struct AppDesc {
  var name: String
  var icon: NSImage?
}

class AppHelper {
  public static let shared = AppHelper()
  
  public func getRunningApps() -> [AppDesc] {
    let apps = NSWorkspace.shared.runningApplications
    var ret : [AppDesc] = []
    for app in apps {
      ret.append(AppDesc(name: app.localizedName ?? "<unknown>", icon: app.icon))
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
