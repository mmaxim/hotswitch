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
  var window: NSWindow!
  var hotkeyModel = HotKeyModel()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainView = HotKeyGrid()
      .environmentObject(hotkeyModel)
    
    // Create the window and set the content view.
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.isReleasedWhenClosed = false
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: mainView)
    window.makeKeyAndOrderFront(nil)
    
    let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    AXIsProcessTrustedWithOptions(options)
    
    HotKeysRegistrar.shared().delegate = self
    HotKeysRegistrar.shared().syncHotKeys(hotkeyModel.getHotKeysForBridge())
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
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  
}

