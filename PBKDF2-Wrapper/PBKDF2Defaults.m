//
//  PBKDF2Defaults.m
//  PBKDF2-Wrapper
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "PBKDF2Defaults.h"

NSUInteger PBKDF2DefaultDerivedKeyLength                     = 32;
uint32_t   PBKDF2DefaultDelayInMilliseconds                  = 100;
NSUInteger PBKDF2DefaultSaltLength                           = 64;
NSUInteger PBKDF2DefaultRounds                               = 10000;
PBKDF2PseudoRandomFunction PBKDF2DefaultPseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA1;
