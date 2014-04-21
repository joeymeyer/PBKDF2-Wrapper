//
//  PBKDF2Defaults.h
//  PBKDF2-Wrapper
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBKDF2Configuration.h"

extern NSUInteger PBKDF2DefaultDerivedKeyLength;
extern uint32_t   PBKDF2DefaultDelayInMilliseconds;
extern NSUInteger PBKDF2DefaultSaltLength;
extern NSUInteger PBKDF2DefaultRounds;
extern PBKDF2PseudoRandomFunction PBKDF2DefaultPseudoRandomFunction;
