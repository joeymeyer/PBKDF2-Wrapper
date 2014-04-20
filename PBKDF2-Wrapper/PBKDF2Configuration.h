//
//  PBKDF2Configuration.h
//  PBKDF2-Wrapper Example
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonKeyDerivation.h>

typedef NS_ENUM(NSUInteger, PBKDF2PseudoRandomFunction) {
  PBKDF2PseudoRandomFunctionSHA1 = 0,
  PBKDF2PseudoRandomFunctionSHA224,
  PBKDF2PseudoRandomFunctionSHA256,
  PBKDF2PseudoRandomFunctionSHA384,
  PBKDF2PseudoRandomFunctionSHA512
};

NSData * PBKDF2SaltWithLength(NSUInteger length);
CCPseudoRandomAlgorithm CCPseudoRandomAlgorithmFromPBKDF2PseudoRandomFunction(PBKDF2PseudoRandomFunction pseudoRandomFunction);
NSString * NSStringFromPBKDF2PseudoRandomFunction(PBKDF2PseudoRandomFunction pseudoRandomFunction);

@interface PBKDF2Configuration : NSObject <NSCopying, NSSecureCoding>

@property(nonatomic,copy,readonly) NSData *salt;

@property(nonatomic,readonly) NSUInteger derivedKeyLength;

@property(nonatomic,readonly) NSUInteger rounds;

@property(nonatomic,readonly) PBKDF2PseudoRandomFunction pseudoRandomFunction;

- (instancetype)initWithPasswordLength:(NSUInteger)passwordLength
                      derivedKeyLength:(NSUInteger)derivedKeyLength
                            saltLength:(NSUInteger)saltLength
          estimatedDelayInMilliseconds:(NSUInteger)delayInMilliseconds;

- (instancetype)initWithDerivedKeyLength:(NSUInteger)derivedKeyLength
                              saltLength:(NSUInteger)saltLength
                                  rounds:(NSUInteger)rounds
                    pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction;

- (instancetype)initWithSalt:(NSData *)salt
            derivedKeyLength:(NSUInteger)derivedKeyLength
                      rounds:(NSUInteger)rounds
        pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction;

@end
