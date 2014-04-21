//
//  PBKDF2Configuration.m
//  PBKDF2-Wrapper Example
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "PBKDF2Configuration.h"
#import "PBKDF2Defaults.h"
#import <Security/Security.h>

NSData * PBKDF2SaltWithLength(NSUInteger length) {
  NSMutableData *randomData = [NSMutableData dataWithLength:length];
  SecRandomCopyBytes(kSecRandomDefault, (size_t)length, [randomData mutableBytes]);
  return [NSData dataWithData:randomData];
}

PBKDF2PseudoRandomFunction PBKDF2PseudoRandomFunctionFromCCPseudoRandomAlgorithm(CCPseudoRandomAlgorithm algorithm) {
  PBKDF2PseudoRandomFunction pseudoRandomFunction;
  
  switch (algorithm) {
    case kCCHmacAlgSHA1:
      pseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA1;
      break;
    case kCCHmacAlgSHA224:
      pseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA224;
      break;
    case kCCHmacAlgSHA256:
      pseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA256;
      break;
    case kCCHmacAlgSHA384:
      pseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA384;
      break;
    case kCCHmacAlgSHA512:
      pseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA512;
      break;
    default:
      pseudoRandomFunction = PBKDF2PseudoRandomFunctionSHA1;
      break;
  }
  
  return pseudoRandomFunction;
}

CCPseudoRandomAlgorithm CCPseudoRandomAlgorithmFromPBKDF2PseudoRandomFunction(PBKDF2PseudoRandomFunction pseudoRandomFunction) {
  CCPseudoRandomAlgorithm algorithm;
  
  switch (pseudoRandomFunction) {
    case PBKDF2PseudoRandomFunctionSHA1:
      algorithm = kCCPRFHmacAlgSHA1;
      break;
    case PBKDF2PseudoRandomFunctionSHA224:
      algorithm = kCCPRFHmacAlgSHA224;
      break;
    case PBKDF2PseudoRandomFunctionSHA256:
      algorithm = kCCPRFHmacAlgSHA256;
      break;
    case PBKDF2PseudoRandomFunctionSHA384:
      algorithm = kCCPRFHmacAlgSHA384;
      break;
    case PBKDF2PseudoRandomFunctionSHA512:
      algorithm = kCCPRFHmacAlgSHA512;
      break;
    default:
      algorithm = kCCPRFHmacAlgSHA1;
      break;
  }
  
  return algorithm;
}

NSString * NSStringFromPBKDF2PseudoRandomFunction(PBKDF2PseudoRandomFunction pseudoRandomFunction) {
  NSString *pseudoRandomFunctionString;
  
  switch (pseudoRandomFunction) {
    case PBKDF2PseudoRandomFunctionSHA1:
      pseudoRandomFunctionString = @"SHA1";
      break;
    case PBKDF2PseudoRandomFunctionSHA224:
      pseudoRandomFunctionString = @"SHA224";
      break;
    case PBKDF2PseudoRandomFunctionSHA256:
      pseudoRandomFunctionString = @"SHA256";
      break;
    case PBKDF2PseudoRandomFunctionSHA384:
      pseudoRandomFunctionString = @"SHA384";
      break;
    case PBKDF2PseudoRandomFunctionSHA512:
      pseudoRandomFunctionString = @"SHA512";
      break;
    default:
      pseudoRandomFunctionString = @"SHA1";
      break;
  }
  
  return pseudoRandomFunctionString;
}

@interface PBKDF2Configuration()

@property(nonatomic,copy,readwrite) NSData *salt;
@property(nonatomic,readwrite) NSUInteger derivedKeyLength;
@property(nonatomic,readwrite) NSUInteger rounds;
@property(nonatomic,readwrite) PBKDF2PseudoRandomFunction pseudoRandomFunction;

@end

@implementation PBKDF2Configuration

#pragma mark - Object Lifecycle

- (instancetype)init {
  return [self initWithDerivedKeyLength:PBKDF2DefaultDerivedKeyLength
                             saltLength:PBKDF2DefaultSaltLength
                                 rounds:PBKDF2DefaultRounds
                   pseudoRandomFunction:PBKDF2DefaultPseudoRandomFunction];
}

- (instancetype)initWithPasswordLength:(NSUInteger)passwordLength
                      derivedKeyLength:(NSUInteger)derivedKeyLength
                            saltLength:(NSUInteger)saltLength
                  pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction
          estimatedDelayInMilliseconds:(uint32_t)delayInMilliseconds {
  NSData *salt = PBKDF2SaltWithLength(saltLength);
  
  NSUInteger rounds = CCCalibratePBKDF(kCCPBKDF2,
                                       passwordLength,
                                       saltLength,
                                       CCPseudoRandomAlgorithmFromPBKDF2PseudoRandomFunction(pseudoRandomFunction),
                                       derivedKeyLength,
                                       delayInMilliseconds);
  
  return [self initWithSalt:salt
           derivedKeyLength:derivedKeyLength
                     rounds:rounds
       pseudoRandomFunction:pseudoRandomFunction];
}

- (instancetype)initWithDerivedKeyLength:(NSUInteger)derivedKeyLength
                              saltLength:(NSUInteger)saltLength
                                  rounds:(NSUInteger)rounds
                    pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction {
  NSData *salt = PBKDF2SaltWithLength(saltLength);
  
  return [self initWithSalt:salt
           derivedKeyLength:derivedKeyLength
                     rounds:rounds
       pseudoRandomFunction:pseudoRandomFunction];
}

- (instancetype)initWithSalt:(NSData *)salt
            derivedKeyLength:(NSUInteger)derivedKeyLength
                      rounds:(NSUInteger)rounds
        pseudoRandomFunction:(PBKDF2PseudoRandomFunction)pseudoRandomFunction {
  self = [super init];
  if (self) {
    self.salt = salt;
    self.derivedKeyLength = derivedKeyLength;
    self.rounds = rounds;
    self.pseudoRandomFunction = pseudoRandomFunction;
  }
  return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
  return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.salt = [aDecoder decodeObjectOfClass:[NSData class]
                                       forKey:NSStringFromSelector(@selector(salt))];
    self.derivedKeyLength = [[aDecoder decodeObjectOfClass:[NSNumber class]
                                                    forKey:NSStringFromSelector(@selector(derivedKeyLength))] unsignedIntegerValue];
    self.rounds = [[aDecoder decodeObjectOfClass:[NSNumber class]
                                          forKey:NSStringFromSelector(@selector(rounds))] unsignedIntegerValue];
    self.pseudoRandomFunction = [[aDecoder decodeObjectOfClass:[NSNumber class]
                                                        forKey:NSStringFromSelector(@selector(pseudoRandomFunction))] unsignedIntegerValue];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.salt forKey:NSStringFromSelector(@selector(salt))];
  [aCoder encodeObject:@(self.derivedKeyLength) forKey:NSStringFromSelector(@selector(derivedKeyLength))];
  [aCoder encodeObject:@(self.rounds) forKey:NSStringFromSelector(@selector(rounds))];
  [aCoder encodeObject:@(self.pseudoRandomFunction) forKey:NSStringFromSelector(@selector(pseudoRandomFunction))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initWithSalt:[self.salt copyWithZone:zone]
                                        derivedKeyLength:self.derivedKeyLength
                                                  rounds:self.rounds
                                    pseudoRandomFunction:self.pseudoRandomFunction];
}

#pragma mark - Description

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %p, salt: %@, derivedKeyLength: %lu, rounds: %lu, pseudoRandomFunction: %@>", NSStringFromClass([self class]), self, self.salt, (unsigned long)self.derivedKeyLength, (unsigned long)self.rounds, NSStringFromPBKDF2PseudoRandomFunction(self.pseudoRandomFunction)];
}

#pragma mark - Overridden Properties

- (void)setRounds:(NSUInteger)rounds {
  _rounds = MAX(rounds, 1);
}

@end
