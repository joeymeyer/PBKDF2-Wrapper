//
//  PBKDF2Result.h
//  PBKDF2-Wrapper
//
//  Created by Joey Meyer on 4/19/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBKDF2Configuration.h"

@interface PBKDF2Result : NSObject <NSCopying, NSSecureCoding>

@property(nonatomic,strong,readonly) PBKDF2Configuration *configuration;

@property(nonatomic,copy,readonly) NSData *derivedKey;

- (void)calculateDerivedKey;

- (instancetype)initWithPassword:(NSString *)password;

- (instancetype)initWithPassword:(NSString *)password
                derivedKeyLength:(NSUInteger)derivedKeyLength;

- (instancetype)initWithPassword:(NSString *)password
                   configuration:(PBKDF2Configuration *)configuration;

@end
