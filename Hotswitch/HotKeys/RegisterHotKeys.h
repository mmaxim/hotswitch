//
//  RegisterHotKeys.h
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/6/21.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

#pragma once

@interface HotKeyBridge : NSObject

@property NSString* appName;
@property int keyCode;
@property int mod;

- (instancetype)init;

@end

@protocol HotKeysRegistrarDelegate

- (void) onHotKeyDown:(HotKeyBridge*)hotKey;
- (void) onHotKeyUp;

@end

@interface HotKeysRegistrar : NSObject

+(instancetype)shared;

@property(nonatomic, weak) id<HotKeysRegistrarDelegate> delegate;

- (void)syncHotKeys:(NSArray*)hotKeys;
- (void)handleKeyDown:(EventRef)anEvent;
- (void)handleKeyUp;

@end

@interface HotKeyConverter : NSObject

+ (NSString*)keyCodeToString:(SInt32)keyCode andMod:(SInt32)modCode;
+ (SInt32)nsEventModToCarbon:(SInt32)mod;

@end
