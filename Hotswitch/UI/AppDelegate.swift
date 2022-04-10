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
  var configWindows : [NSWindow] = []
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainView = RootView()
      .background(Color(NSColor.windowBackgroundColor))
      .environmentObject(hotkeyModel)
    
    HotKeysRegistrar.shared().delegate = self
    HotKeysRegistrar.shared().syncHotKeys(hotkeyModel.getHotKeysForBridge())
    
    NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged]) {
      switch $0.modifierFlags.intersection(.deviceIndependentFlagsMask) {
      case [.option]:
        let isRight = $0.modifierFlags.rawValue & UInt(NX_DEVICERALTKEYMASK) != 0
        if (isRight) {
          self.showGlobalConfigWindow()
        }
      default:
        self.hideGlobalConfigWindow()
      }
    }
    
    popover.contentSize = NSSize(width: 600, height: 450)
    popover.contentViewController = NSHostingController(rootView: mainView)
    statusBar = StatusBarController(popover)
  }
  
  func showGlobalConfigWindow() {
    let windowbkg = NSWindow(
        contentRect: NSMakeRect(0, 0, 600, 450),
        styleMask: [],
        backing: .buffered,
        defer: false)
    windowbkg.level = .screenSaver
    windowbkg.makeKeyAndOrderFront(windowbkg)
    windowbkg.isReleasedWhenClosed = false
    windowbkg.isOpaque = false
    windowbkg.backgroundColor = NSColor.clear
    windowbkg.setFrameOriginToPositionWindowInCenterOfScreen()
    
    let effect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
    effect.blendingMode = .behindWindow
    effect.state = .active
    effect.material = .popover
    effect.wantsLayer = true
    effect.layer?.cornerRadius = 15.0
    effect.appearance = NSAppearance(named: .darkAqua)
    windowbkg.contentView = effect
    
    configWindows.append(windowbkg)
    
    
    let window = NSWindow(
        contentRect: NSMakeRect(0, 0, 600, 450),
        styleMask: [],
        backing: .buffered,
        defer: false)
    window.level = .screenSaver
    window.makeKeyAndOrderFront(window)
    window.isReleasedWhenClosed = false
    window.isOpaque = false
    window.backgroundColor = NSColor.clear
    window.setFrameOriginToPositionWindowInCenterOfScreen()
    configWindows.append(window)
    
    let view = NSHostingView(rootView: GlobalConfigView()
      .environmentObject(hotkeyModel))
    window.contentView = view
  }
  
  func hideGlobalConfigWindow() {
    for window in configWindows {
      window.close()
    }
    configWindows = []
  }
  
  func onHotKeyUp() {}
  
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

extension NSWindow {
  public func setFrameOriginToPositionWindowInCenterOfScreen() {
    if let screenSize = screen?.frame.size {
      self.setFrameOrigin(NSPoint(x: (screenSize.width-frame.size.width)/2, y: (screenSize.height-frame.size.height)/2))
    }
  }
}

