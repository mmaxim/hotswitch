//
//  RegisterHotKeys.m
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#include <CoreGraphics/CGEventSource.h>
#import "RegisterHotKeys.h"
#include <array>

static OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void* userData) {
  if (userData == nullptr) {
    return noErr;
  }
  EventHotKeyID hotKeyID;
  
  GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, nil, sizeof(EventHotKeyID), nil, &hotKeyID);
  auto delegate = (__bridge id<HotKeysRegistrarDelegate>)userData;
  [delegate onHotKeyDown:hotKeyID.id];
  return noErr;
}

@implementation HotKeysRegistrar

+ (instancetype)shared {
  static HotKeysRegistrar* hkr = nullptr;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    hkr = [[self alloc] init];
  });
  return hkr;
}

- (void) registerHotKey:(UInt32)keyCode {
  EventHotKeyID hotKeyID;
  hotKeyID.signature = 'knps' + keyCode;
  hotKeyID.id = keyCode;
  EventHotKeyRef hotKeyRef;
  auto status = RegisterEventHotKey(keyCode, 0, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
  if (status != noErr) {
    NSLog(@"failed to register event hot key: %d", status);
    return;
  }
}

- (void) registerHotKeys {
  [self registerHotKey:kVK_ANSI_Keypad1];
  [self registerHotKey:kVK_ANSI_Keypad2];
  [self registerHotKey:kVK_ANSI_Keypad3];
  [self registerHotKey:kVK_ANSI_Keypad4];
  [self registerHotKey:kVK_ANSI_Keypad5];
  [self registerHotKey:kVK_ANSI_Keypad6];
  [self registerHotKey:kVK_ANSI_Keypad7];
  [self registerHotKey:kVK_ANSI_Keypad8];
  [self registerHotKey:kVK_ANSI_Keypad9];
  
  std::array<EventTypeSpec, 2> eventTypes;
  eventTypes[0].eventClass = kEventClassKeyboard;
  eventTypes[0].eventKind = kEventHotKeyPressed;
  auto status = InstallApplicationEventHandler(hotKeyHandler, eventTypes.size(), eventTypes.data(),
                                               (__bridge void*)_delegate, NULL);
  if (status != noErr) {
    NSLog(@"failed to install event handler: %d", status);
    return;
  }
  //[self registerHotKey:kVK_ANSI_Keypad6 andHandler:hotKeyHandler6 andID:6];
  //[self registerHotKey:kVK_ANSI_Keypad7 andHandler:hotKeyHandler7 andID:7];
  //[self registerHotKey:kVK_ANSI_Keypad8 andHandler:hotKeyHandler8 andID:8];
  //[self registerHotKey:kVK_ANSI_Keypad9 andHandler:hotKeyHandler9 andID:9];
}

@end
