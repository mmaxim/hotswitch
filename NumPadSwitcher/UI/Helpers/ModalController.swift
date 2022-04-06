//
//  ModalController.swift
//  NumPadSwitcher
//
//  Created by Mike Maxim on 4/4/22.
//

import Foundation
import Cocoa
import SwiftUI

class ModalController<Content: View>: NSWindowController, NSWindowDelegate {
  init(width: Int, height: Int, @ViewBuilder content: @escaping () -> Content) {
    let mainView = content()
    let window = NSWindow(
      contentRect: CGRect(x: 0, y: 0, width: width, height: height),
      styleMask: [.titled, .closable],
      backing: .buffered,
      defer: false
    )
    let hosting = NSHostingView(rootView: mainView)
    window.contentView = hosting
    super.init(window: window)
    window.delegate = self
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  func windowDidBecomeKey(_ notification: Notification) {
    window?.level = .statusBar
  }
  func windowWillClose(_ notification: Notification) {
    NSApp.stopModal()
  }
}
