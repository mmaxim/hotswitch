//
//  RegisterHotKeys.h
//  NumPadSwitcher
//
//  Created by Michael Maxim on 6/6/21.
//

#include <Foundation/Foundation.h>

#pragma once

@protocol HotKeysRegistrarDelegate

- (void) onHotKeyDown:(UInt32)keyCode;

@end

@interface HotKeysRegistrar : NSObject

+(instancetype)shared;

@property(nonatomic, weak) id<HotKeysRegistrarDelegate> delegate;

- (void)registerHotKeys;

@end
