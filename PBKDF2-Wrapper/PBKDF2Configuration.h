//
//  PBKDF2Configuration.h
//  PBKDF2-Wrapper Example
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonKeyDerivation.h>

/**
 Represents the possible pseudo random functions to be used when computing PBKDF2.
 */
typedef NS_ENUM(NSUInteger, PBKDF2PseudoRandomFunction) {
  /**
   HMAC SHA-1
   */
  PBKDF2PseudoRandomFunctionSHA1 = 0,
  /**
   HMAC SHA-224
   */
  PBKDF2PseudoRandomFunctionSHA224,
  /**
   HMAC SHA-256
   */
  PBKDF2PseudoRandomFunctionSHA256,
  /**
   HMAC SHA-384
   */
  PBKDF2PseudoRandomFunctionSHA384,
  /**
   HMAC SHA-512
   */
  PBKDF2PseudoRandomFunctionSHA512
};

/**
 Helper function to create a secure random salt of a given length.
 
 @param length Length, in bytes, of the salt.
 
 @warning Will return `nil` if there is an error retrieving random data.
 
 @return The newly created secure random salt.
 */
NSData * PBKDF2SaltWithLength(NSUInteger length);

/**
 Convenience function for getting the `CCPseudoRandomAlgorithm` equivalent of a `PBKDF2PseudoRandomFunction`.
 
 @param pseudoRandomFunction The pseudo random function to find the equivalent `CCPseudoRandomAlgorithm` for.
 
 @return The equivalent `CCPseudoRandomAlgorithm`.
 */
CCPseudoRandomAlgorithm CCPseudoRandomAlgorithmFromPBKDF2PseudoRandomFunction(PBKDF2PseudoRandomFunction pseudoRandomFunction);

/**
 Helper method for getting an `NSString` representation for a given pseudo random function.
 
 @discussion This is really only useful for debug purposes.
 
 @param pseudoRandomFunction The pseudo random function to get a string for.
 
 @return `NSString` representation of the pseudo random function.
 */
NSString * NSStringFromPBKDF2PseudoRandomFunction(PBKDF2PseudoRandomFunction pseudoRandomFunction);

/**
 `PBKDF2Configuration` contains all the information needed (other than the password) to compute PBKDF2.
 
 @discussion There a several initializers for creating configurations to be passed into a `PBKDF2Result` for use. This class conveniently conforms to `NSCoding` so it can easily be archived to disk so the same configuration can be used each time.
 */
@interface PBKDF2Configuration : NSObject <NSCopying, NSSecureCoding>

/**
 `NSData` representation of the salt to be used in PBKDF2.
 */
@property(nonatomic,copy,readonly) NSData *salt;

/**
 The length, in bytes, of the derived key.
 */
@property(nonatomic,readonly) NSUInteger derivedKeyLength;

/**
 The number of iterations the pseudo random function should be computer in PBKDF2.
 */
@property(nonatomic,readonly) NSUInteger rounds;

/**
 The pseudo random function to be used when computing PBKDF2.
 */
@property(nonatomic,readonly) PBKDF2PseudoRandomFunction pseudoRandomFunction;

/**
 Initializer which returns a configuration with a calibrated number of rounds given the remaining configuration information and an estimated delay. It will also automatically generate a secure random salt of the given length.
 
 @param passwordLength       The length of the password.
 @param derivedKeyLength     The length, in bytes, of the derived key.
 @param saltLength           The length, in bytes, of the salt.
 @param pseudoRandomFunction The pseudo random function to be used in PBKDF2.
 @param delayInMilliseconds  The estimated delay in milliseconds the PBKDF2 calculation should take.
 
 @return The newly initialized `PBKDF2Configuration`.
 */
- (instancetype)initWithPasswordLength:(NSUInteger)passwordLength
                      derivedKeyLength:(NSUInteger)derivedKeyLength
                            saltLength:(NSUInteger)saltLength
                  pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction
          estimatedDelayInMilliseconds:(uint32_t)delayInMilliseconds;

/**
 Initializer which returns a configuration with a generated secure random salt of the given length, along with the rest of the passed in arguments.
 
 @param derivedKeyLength     The length, in bytes, of the derived key.
 @param saltLength           The length, in bytes, of the salt.
 @param rounds               The number of rounds for the PBKDF2 calculation.
 @param pseudoRandomFunction The pseudo random function to be used in PBKDF2.
 
 @return The newly initialized `PBKDF2Configuration`.
 */
- (instancetype)initWithDerivedKeyLength:(NSUInteger)derivedKeyLength
                              saltLength:(NSUInteger)saltLength
                                  rounds:(NSUInteger)rounds
                    pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction;

/**
 Explicit initializer which returns a configuration with the arguments passed in.
 
 @param salt                 The salt for the PBKDF2 calculation.
 @param derivedKeyLength     The length, in bytes, of the derived key.
 @param rounds               The number of rounds for the PBKDF2 calculation.
 @param pseudoRandomFunction The pseudo random function to be used in PBKDF2.
 
 @return The newly initialized `PBKDF2Configuration`.
 */
- (instancetype)initWithSalt:(NSData *)salt
            derivedKeyLength:(NSUInteger)derivedKeyLength
                      rounds:(NSUInteger)rounds
        pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction;

@end
