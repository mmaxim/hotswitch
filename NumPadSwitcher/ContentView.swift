//
//  ContentView.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/6/21.
//

import SwiftUI

struct ContentView: View {
  func getRunningApps() -> [String] {
    let apps = NSWorkspace.shared.runningApplications
    var ret : [String] = []
    for app in apps {
      ret.append(app.localizedName ?? "<unknown>")
    }
    return ret
    /*AXUIElementRef appRef = AXUIElementCreateApplication([app processIdentifier]);
     if (AXUIElementSetAttributeValue(appRef, (CFStringRef)NSAccessibilityFrontmostAttribute, kCFBooleanTrue) != kAXErrorSuccess) {
       SlateLogger(@"ERROR: Could not change focus to app");
       if (appRef != NULL) CFRelease(appRef);
       return NO;
     }
     if (appRef != NULL) CFRelease(appRef);
     return YES;
   }*/
  }
  
 
  
  var body: some View {
    VStack {
      List {
        ForEach(getRunningApps(), id: \.self) { app in
          Text(app)
        }
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
