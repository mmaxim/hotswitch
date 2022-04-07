//
//  AppDelegate.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/6/21.
//

import Cocoa
import SwiftUI
import Carbon

@main
class AppDelegate: NSObject, NSApplicationDelegate, HotKeysRegistrarDelegate {
  var hotkeyModel = HotKeyModel()
  var statusBar : StatusBarController?
  var popover = NSPopover()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainView = RootView()
      .background(Color(NSColor.windowBackgroundColor))
      .environmentObject(hotkeyModel)
    
    HotKeysRegistrar.shared().delegate = self
    HotKeysRegistrar.shared().syncHotKeys(hotkeyModel.getHotKeysForBridge())
    
    popover.contentSize = NSSize(width: 600, height: 450)
    popover.contentViewController = NSHostingController(rootView: mainView)
    //popover.setValue(true, forKeyPath: "shouldHideAnchor")
    
    statusBar = StatusBarController(popover)
  }
  
  func onHotKeyDown(_ hotKey : HotKeyBridge) {
    let apps = NSWorkspace.shared.runningApplications
    let name = hotKey.appName
    for app in apps {
      if app.localizedName == name {
        
        let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: app.bundleIdentifier!)
        print("opening: " + app.bundleIdentifier!)
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.openApplication(at: url!,
                                           configuration: configuration,
                                           completionHandler: nil)
        break
      }
    }
  }
}

