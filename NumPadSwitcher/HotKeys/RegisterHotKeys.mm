//
//  RegisterHotKeys.m
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>
#include <CoreGraphics/CGEventSource.h>
#import "RegisterHotKeys.h"
#include <array>
#include <vector>
#include <string>
#include <optional>

static OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void* userData) {
  if (userData == nullptr) {
    return noErr;
  }
  auto registrar = (__bridge HotKeysRegistrar*)userData;
  [registrar handleKeyDown:anEvent];
  return noErr;
}

class RegisteredHotKey {
  HotKeyBridge* hotKey_ = nullptr;
  EventHotKeyRef ref_ = nullptr;
  EventHotKeyID hotKeyId_;
  
public:
  
  RegisteredHotKey(HotKeyBridge* hotKey, EventHotKeyRef ref, EventHotKeyID hotKeyId)
  : hotKey_(hotKey), ref_(ref), hotKeyId_(hotKeyId) {}
  
  HotKeyBridge* get_hotkey() const { return hotKey_; }
  EventHotKeyRef get_ref() const { return ref_; }
  EventHotKeyID get_id() const { return hotKeyId_; }
};

@implementation HotKeysRegistrar {
  std::vector<RegisteredHotKey> registeredKeys;
}

+ (instancetype)shared {
  static HotKeysRegistrar* hkr = nullptr;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    hkr = [[self alloc] init];
  });
  return hkr;
}

- (void) setDelegate:(id<HotKeysRegistrarDelegate>)delegate {
  _delegate = delegate;
  std::array<EventTypeSpec, 2> eventTypes;
  eventTypes[0].eventClass = kEventClassKeyboard;
  eventTypes[0].eventKind = kEventHotKeyPressed;
  auto status = InstallApplicationEventHandler(hotKeyHandler, eventTypes.size(), eventTypes.data(),
                                               (__bridge void*)self, NULL);
  if (status != noErr) {
    NSLog(@"failed to install event handler: %d", status);
    return;
  }
}

- (void) syncHotKeys:(NSArray*)hotKeys {
  // clear current hot keys
  for (const auto& registeredKey : registeredKeys) {
    UnregisterEventHotKey(registeredKey.get_ref());
  }
  registeredKeys.clear();
  
  // register new set of hot keys
  for (HotKeyBridge* hotKey in hotKeys) {
    [self registerHotKey:hotKey];
  }
}

- (void) handleKeyDown:(EventRef)anEvent {
  EventHotKeyID hotKeyID;
  GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, nil, sizeof(EventHotKeyID), nil, &hotKeyID);
  if (hotKeyID.id > registeredKeys.size()) {
    NSLog(@"handleKeyDown: unknown hotkey ID: %d", hotKeyID.id);
    return;
  }
  
  auto reged = registeredKeys[hotKeyID.id];
  [_delegate onHotKeyDown:reged.get_hotkey()];
}

- (void) registerHotKey:(HotKeyBridge*)hotKey {
  EventHotKeyID hotKeyID;
  hotKeyID.signature = 'knps' + hotKey.keyCode + hotKey.mod;
  hotKeyID.id = static_cast<int>(registeredKeys.size());
  EventHotKeyRef hotKeyRef;
  auto status = RegisterEventHotKey(hotKey.keyCode, hotKey.mod, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
  if (status != noErr) {
    NSLog(@"failed to register event hot key: %d", status);
    return;
  }
  registeredKeys.emplace_back(hotKey, hotKeyRef, hotKeyID);
}

@end

@implementation HotKeyBridge

- (instancetype)init {
  self = [super init];
  return self;
}

@end

static std::string getKeyCodeStr(SInt32 keyCode) {
  if (keyCode < 0) {
    return "";
  }
  switch (keyCode) {
    case kVK_ANSI_A:
      return "a";
    case kVK_ANSI_B:
      return "b";
    case kVK_ANSI_C:
      return "c";
    case kVK_ANSI_D:
      return "d";
    case kVK_ANSI_E:
      return "e";
    case kVK_ANSI_F:
      return "f";
    case kVK_ANSI_G:
      return "g";
    case kVK_ANSI_H:
      return "h";
    case kVK_ANSI_I:
      return "i";
    case kVK_ANSI_J:
      return "j";
    case kVK_ANSI_K:
      return "k";
    case kVK_ANSI_L:
      return "l";
    case kVK_ANSI_M:
      return "m";
    case kVK_ANSI_N:
      return "n";
    case kVK_ANSI_O:
      return "o";
    case kVK_ANSI_P:
      return "p";
    case kVK_ANSI_Q:
      return "q";
    case kVK_ANSI_R:
      return "r";
    case kVK_ANSI_S:
      return "s";
    case kVK_ANSI_T:
      return "t";
    case kVK_ANSI_U:
      return "u";
    case kVK_ANSI_V:
      return "v";
    case kVK_ANSI_W:
      return "w";
    case kVK_ANSI_X:
      return "x";
    case kVK_ANSI_Y:
      return "y";
    case kVK_ANSI_Z:
      return "z";
    case kVK_ANSI_KeypadClear:
      return "Clear";
    case kVK_ANSI_KeypadEquals:
      return "=";
    case kVK_ANSI_KeypadMultiply:
      return "*";
    case kVK_ANSI_KeypadDivide:
      return "/";
    case kVK_ANSI_KeypadMinus:
      return "-";
    case kVK_ANSI_KeypadPlus:
      return "+";
    case kVK_ANSI_KeypadEnter:
      return "Enter";
    case kVK_ANSI_KeypadDecimal:
      return ".";
    case kVK_ANSI_Keypad0:
      return "NumPad-0";
    case kVK_ANSI_Keypad1:
      return "NumPad-1";
    case kVK_ANSI_Keypad2:
      return "NumPad-2";
    case kVK_ANSI_Keypad3:
      return "NumPad-3";
    case kVK_ANSI_Keypad4:
      return "NumPad-4";
    case kVK_ANSI_Keypad5:
      return "NumPad-5";
    case kVK_ANSI_Keypad6:
      return "NumPad-6";
    case kVK_ANSI_Keypad7:
      return "NumPad-7";
    case kVK_ANSI_Keypad8:
      return "NumPad-8";
    case kVK_ANSI_Keypad9:
      return "NumPad-9";
    case kVK_ANSI_0:
      return "0";
    case kVK_ANSI_1:
      return "1";
    case kVK_ANSI_2:
      return "2";
    case kVK_ANSI_3:
      return "3";
    case kVK_ANSI_4:
      return "4";
    case kVK_ANSI_5:
      return "5";
    case kVK_ANSI_6:
      return "6";
    case kVK_ANSI_7:
      return "7";
    case kVK_ANSI_8:
      return "8";
    case kVK_ANSI_9:
      return "9";
    case kVK_Return:
      return "Return";
    case kVK_Tab:
      return "Tab";
    case kVK_Delete:
      return "Delete";
    case kVK_Escape:
      return "ESC";
    case kVK_Command:
      return "Cmd";
    case kVK_RightCommand:
      return "Right-Cmd";
    case kVK_Shift:
      return "Shift";
    case kVK_RightShift:
      return "Right-Shift";
    case kVK_CapsLock:
      return "Caps Lock";
    case kVK_Option:
      return "Option";
    case kVK_RightOption:
      return "Right-Option";
    case kVK_Control:
      return "Control";
    case kVK_RightControl:
      return "Right-Control";
    case kVK_Function:
      return "Fn";
    case kVK_VolumeUp:
      return "VolUp";
    case kVK_VolumeDown:
      return "VolDown";
    case kVK_Mute:
      return "Mute";
    case kVK_F1:
      return "F1";
    case kVK_F2:
      return "F2";
    case kVK_F3:
      return "F3";
    case kVK_F4:
      return "F4";
    case kVK_F5:
      return "F5";
    case kVK_F6:
      return "F6";
    case kVK_F7:
      return "F7";
    case kVK_F8:
      return "F8";
    case kVK_F9:
      return "F9";
    case kVK_F10:
      return "F10";
    case kVK_F11:
      return "F11";
    case kVK_F12:
      return "F12";
    case kVK_F13:
      return "F13";
    case kVK_Home:
      return "Home";
    case kVK_PageUp:
      return "PgUp";
    case kVK_ForwardDelete:
      return "Delete";
    case kVK_End:
      return "End";
    case kVK_PageDown:
      return "PgDn";
    case kVK_LeftArrow:
      return "LeftArrow";
    case kVK_RightArrow:
      return "RightArrow";
    case kVK_DownArrow:
      return "DownArrow";
    case kVK_UpArrow:
      return "UpArrow";
    case kVK_Space:
      return "Space";
  }
  return "Code: " + std::to_string(keyCode);
}

static std::string getModStr(SInt32 mod) {
  if (mod < 0) {
    return "";
  }
  std::vector<std::string> mods;
  if ((mod & NSEventModifierFlagCapsLock) != 0) {
    mods.push_back("⇪");
  }
  if ((mod & NSEventModifierFlagCommand) != 0) {
    mods.push_back("⌘");
  }
  if ((mod & NSEventModifierFlagShift) != 0) {
    mods.push_back("⇧");
  }
  if ((mod & NSEventModifierFlagOption) != 0) {
    mods.push_back("⌥");
  }
  if ((mod & NSEventModifierFlagControl) != 0) {
    mods.push_back("^");
  }
  std::string ret;
  for (const auto& mod : mods) {
    ret += mod;
  }
  return ret;
}

@implementation HotKeyConverter


+ (NSString*)keyCodeToString:(SInt32)keyCode andMod:(SInt32)modCode {
  auto keyCodeStr = getKeyCodeStr(keyCode);
  if (keyCodeStr.empty()) {
    return nil;
  }
  auto modCodeStr = getModStr(modCode);
  return (modCodeStr.empty()) ?
    [NSString stringWithUTF8String:keyCodeStr.c_str()] :
    [NSString stringWithFormat:@"%@%@",
      [NSString stringWithUTF8String:modCodeStr.c_str()],
      [NSString stringWithUTF8String:keyCodeStr.c_str()]];
}

@end
