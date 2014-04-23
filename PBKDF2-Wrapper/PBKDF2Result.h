//
//  PBKDF2Result.h
//  PBKDF2-Wrapper
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBKDF2Configuration.h"

/**
 `PBKDF2Result` provides an easy way of computing PBKDF2 for a given password. It also stores a reference to the `PBKDF2Configuration` which includes information (key length, salt, rounds, pseudo random function) about how the key was computed.
 */
@interface PBKDF2Result : NSObject <NSCopying, NSSecureCoding>

/**
 Reference to configuration used to compute the `derivedKey`.
 */
@property(nonatomic,strong,readonly) PBKDF2Configuration *configuration;

/**
 The key returned from the PBKDF2 algorithm.
 
 @discussion The first time this is called it will automatically call `calculateDerivedKey` if the key has not already been calculated.
 
 @see PBKDF2Result -calculateDerivedKey
 */
@property(nonatomic,copy,readonly) NSData *derivedKey;

/**
 Calculates the derived key.
 
 @discussion This will automatically be called the first time `derivedKey` is called.
 
 @warning If the configuration has a high number of rounds this method may take a long time. Using the default configuration (which calculates the number of rounds), this method will take approximately 100ms to finish.
 */
- (void)calculateDerivedKey;

/**
 Default initializer which takes just a password as an argument.
 
 @discussion This will automatically generate a `configuration` with a key length of 32 bytes, a secure random salt, a calculated number of rounds to take approximately 100ms to derive the key, and SHA1 for the pseudo random fuction.
 
 @param password The password to compute PBKDF2 on.
 
 @return The newly initialized `PBKDF2Result`.
 */
- (instancetype)initWithPassword:(NSString *)password;

/**
 Initializer which takes the password and the key length as arguments.
 
 @discussion This method is identical to `initWithPassword:` but allows you to specify the key length.
 
 @param password         The password to compute PBKDF2 on.
 @param derivedKeyLength The length, in bytes, of the derived key.
 
 @return The newly initialized `PBKDF2Result`.
 
 @see PBKDF2Result -initWithPassword:
 */
- (instancetype)initWithPassword:(NSString *)password
                derivedKeyLength:(NSUInteger)derivedKeyLength;

/**
 Initializer which takes the password and the full configuration as arguments.
 
 @discussion When computing the `derivedKey` it will use the information from the configuration passed in.
 
 @param password      The password to compute PBKDF2 on.
 @param configuration The configuration to be used when calculating PBKDF2.
 
 @return The newly initialized `PBKDF2Result`.
 */
- (instancetype)initWithPassword:(NSString *)password
                   configuration:(PBKDF2Configuration *)configuration;

@end
