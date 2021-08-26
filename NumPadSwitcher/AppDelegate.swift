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
  
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()
    
    // Create the window and set the content view.
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.isReleasedWhenClosed = false
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
    
    let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    AXIsProcessTrustedWithOptions(options)
    
    HotKeysRegistrar.shared().delegate = self
    HotKeysRegistrar.shared().registerHotKeys()
  }
  
  func keyCodeToApp(_ keyCode: UInt32) -> String {
    switch (Int(keyCode)) {
    case kVK_ANSI_Keypad5:
      return "Keybase"
    case kVK_ANSI_Keypad3:
      return "Google Chrome"
    case kVK_ANSI_Keypad8:
      return "Xcode"
    case kVK_ANSI_Keypad7:
      return "zoom.us"
    case kVK_ANSI_Keypad2:
      return "iTerm2"
    case kVK_ANSI_Keypad1:
      return "Code"
    default:
      return ""
    }
  }
  
  func onHotKeyDown(_ keyCode: UInt32) {
    let apps = NSWorkspace.shared.runningApplications
    let name = keyCodeToApp(keyCode)
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

