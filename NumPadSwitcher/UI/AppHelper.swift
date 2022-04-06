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
  var inDock: Bool
  
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
      if app.activationPolicy == .prohibited {
        continue
      }
      let bigIcon = app.icon?.copy() as! NSImage?
      bigIcon?.size = NSMakeSize(64,64)
      ret.append(AppDesc(name: app.localizedName ?? "<unknown>", icon: app.icon,
                         bigIcon: bigIcon, inDock: app.activationPolicy == .regular))
    }
    ret.sort {
      if $0.inDock && !$1.inDock {
        return true
      } else if !$0.inDock && $1.inDock {
        return false
      } else {
        return $0.name.lowercased() < $1.name.lowercased()
      }
    }
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

