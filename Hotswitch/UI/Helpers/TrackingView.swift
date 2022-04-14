//
//  TrackingView.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/12/22.
//

import SwiftUI

extension View {
  func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
    TrackingAreaView(onMove: onMove) { self }
  }
}

struct TrackingAreaView<Content>: View where Content : View {
  let onMove: (NSPoint) -> Void
  let content: () -> Content
  
  init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
    self.onMove = onMove
    self.content = content
  }
  
  var body: some View {
    TrackingAreaRepresentable(onMove: onMove, content: self.content)
  }
}

struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
  let onMove: (NSPoint) -> Void
  let content: () -> Content
  
  func makeNSView(context: Context) -> NSHostingView<Content> {
    return TrackingNSHostingView(onMove: onMove, rootView: self.content())
  }
  
  func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
    
    nsView.rootView = self.content()
  }
}

class TrackingNSHostingView<Content>: NSHostingView<Content> where Content : View {
  let onMove: (NSPoint) -> Void
  
  init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
    self.onMove = onMove
    super.init(rootView: rootView)
    
    setupTrackingArea()
  }
  
  required init(rootView: Content) {
    fatalError("init(rootView:) has not been implemented")
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupTrackingArea() {
    let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
    self.addTrackingArea(NSTrackingArea.init(rect: .zero, options: options, owner: self, userInfo: nil))
  }
  
  override func mouseMoved(with event: NSEvent) {
    self.onMove(self.convert(event.locationInWindow, from: nil))
  }
}