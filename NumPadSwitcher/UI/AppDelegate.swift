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
    
    let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    AXIsProcessTrustedWithOptions(options)
    
    HotKeysRegistrar.shared().delegate = self
    HotKeysRegistrar.shared().syncHotKeys(hotkeyModel.getHotKeysForBridge())
    
    popover.contentSize = NSSize(width: 600, height: 450)
    popover.contentViewController = NSHostingController(rootView: mainView)
    popover.setValue(true, forKeyPath: "shouldHideAnchor")
    
    statusBar = StatusBarController(popover)
  }
  
  func onHotKeyDown(_ hotKey : HotKeyBridge) {
    let apps = NSWorkspace.shared.runningApplications
    let name = hotKey.appName
    for app in apps {
      if app.localizedName == name {
        let appRef = AXUIElementCreateApplication(app.processIdentifier)
        print("Attempting")
        if (AXError.success != AXUIElementSetAttributeValue(appRef, NSAccessibility.Attribute.frontmost as CFString, kCFBooleanTrue)) {
          print("Failed")
        }
        break
      }
    }
  }
}

