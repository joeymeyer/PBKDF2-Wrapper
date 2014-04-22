//
//  PBKDF2Defaults.h
//  PBKDF2-Wrapper
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBKDF2Configuration.h"

/**
 The default value for the derived key length, in bytes. (32)
 */
extern NSUInteger PBKDF2DefaultDerivedKeyLength;

/**
 The default value for the delay in milliseconds when calibrating the number of rounds on `PBKDF2Configuration`. (100)
 */
extern uint32_t   PBKDF2DefaultDelayInMilliseconds;

/**
 The default value for the salt length, in bytes. (64)
 */
extern NSUInteger PBKDF2DefaultSaltLength;

/**
 The default value for the number of rounds. (10000)
 */
extern NSUInteger PBKDF2DefaultRounds;

/**
 The default value for the pseudo random function. (PBKDF2PseudoRandomFunctionSHA1)
 */
extern PBKDF2PseudoRandomFunction PBKDF2DefaultPseudoRandomFunction;
