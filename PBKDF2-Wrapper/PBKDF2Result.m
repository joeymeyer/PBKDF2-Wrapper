//
//  PBKDF2Result.m
//  PBKDF2-Wrapper
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "PBKDF2Result.h"
#import "PBKDF2Configuration.h"
#import "PBKDF2Defaults.h"
#import <CommonCrypto/CommonKeyDerivation.h>

@interface PBKDF2Result()

@property(nonatomic,strong,readwrite) PBKDF2Configuration *configuration;
@property(nonatomic,copy,readwrite) NSData *derivedKey;
@property(nonatomic) dispatch_once_t derivedKeyOnceToken;
@property(nonatomic,copy,readwrite) NSString *password;

@end

@implementation PBKDF2Result

#pragma mark - Object Lifecycle

- (instancetype)init {
  return [self initWithPassword:@""];
}

- (instancetype)initWithPassword:(NSString *)password {
  return [self initWithPassword:password derivedKeyLength:PBKDF2DefaultDerivedKeyLength];
}

- (instancetype)initWithPassword:(NSString *)password derivedKeyLength:(NSUInteger)derivedKeyLength {
  PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithPasswordLength:password.length
                                                                          derivedKeyLength:derivedKeyLength
                                                                                saltLength:PBKDF2DefaultSaltLength
                                                              estimatedDelayInMilliseconds:PBKDF2DefaultDelayInMilliseconds];
  
  return [self initWithPassword:password configuration:configuration];
}

- (instancetype)initWithPassword:(NSString *)password
                   configuration:(PBKDF2Configuration *)configuration {
  self = [super init];
  if (self) {
    self.password = password;
    self.configuration = configuration ?: [[PBKDF2Configuration alloc] initWithPasswordLength:password.length
                                                                             derivedKeyLength:PBKDF2DefaultDerivedKeyLength
                                                                                   saltLength:PBKDF2DefaultSaltLength
                                                                 estimatedDelayInMilliseconds:PBKDF2DefaultDelayInMilliseconds];
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
    self.password = [aDecoder decodeObjectOfClass:[NSString class]
                                           forKey:NSStringFromSelector(@selector(password))];
    self.configuration = [aDecoder decodeObjectOfClass:[PBKDF2Configuration class]
                                                forKey:NSStringFromSelector(@selector(configuration))];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.password forKey:NSStringFromSelector(@selector(password))];
  [aCoder encodeObject:self.configuration forKey:NSStringFromSelector(@selector(configuration))];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initWithPassword:self.password
                                               configuration:[self.configuration copyWithZone:zone]];
}

#pragma mark - Description

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %p, configuration: %@, derivedKey: %@>", NSStringFromClass([self class]), self, self.configuration, self.derivedKey];
}

#pragma mark - Public Methods

- (void)calculateDerivedKey {
  dispatch_once(&_derivedKeyOnceToken, ^{
    unsigned char derivedKeyBytes[self.configuration.derivedKeyLength];
    
    NSData *passwordData = [self.password dataUsingEncoding:NSUTF8StringEncoding];
    self.password = nil;
    
    CCKeyDerivationPBKDF(kCCPBKDF2,
                         [passwordData bytes],
                         passwordData.length,
                         [self.configuration.salt bytes],
                         self.configuration.salt.length,
                         CCPseudoRandomAlgorithmFromPBKDF2PseudoRandomFunction(self.configuration.pseudoRandomFunction),
                         (uint)self.configuration.rounds,
                         derivedKeyBytes,
                         self.configuration.derivedKeyLength);
    
    _derivedKey = [NSData dataWithBytes:derivedKeyBytes length:self.configuration.derivedKeyLength];
  });
}

#pragma mark - Overridden Properties

- (NSData *)derivedKey {
  [self calculateDerivedKey];
  
  return [_derivedKey copy];
}

@end
