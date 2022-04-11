//
//  StatusBarController.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/4/22.
//

import AppKit
import SwiftUI

class StatusBarController {
  private var statusBar: NSStatusBar
  private var statusItem: NSStatusItem
  private var popover: NSPopover
  private var monitor: Any?
  
  init(_ popover: NSPopover) {
    self.popover = popover
    statusBar = NSStatusBar()
    statusItem = statusBar.statusItem(withLength: 32.0)
    
    if let statusBarButton = statusItem.button {
      statusBarButton.image = NSApp.applicationIconImage
      statusBarButton.image?.size = NSSize(width: 32.0, height: 32.0)
      statusBarButton.image?.isTemplate = true
      
      statusBarButton.action = #selector(togglePopover(sender:))
      statusBarButton.target = self
    }
  }
  
  deinit {
    stopMonitor()
  }
  
  @objc func togglePopover(sender: Any) {
    if popover.isShown {
      hidePopover(sender)
    } else {
      showPopover(sender)
    }
  }
  
  func showPopover(_ sender: Any) {
    if let statusBarButton = statusItem.button {
      monitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown],
                                                  handler: { (event) in
        self.hidePopover(event)
      })
      popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
      popover.contentViewController?.view.window?.makeKey()
    }
  }
  
  func hidePopover(_ sender: Any) {
    popover.performClose(sender)
    NotificationCenter.default.post(name: .popoverClosed,object: nil)
    stopMonitor()
  }
  
  func stopMonitor() {
    if monitor != nil {
      NSEvent.removeMonitor(monitor!)
      monitor = nil
    }
  }
  
  @objc
  func preferencesModalOpened(_ notification: Notification) {
    hidePopover(notification)
  }
  
}
