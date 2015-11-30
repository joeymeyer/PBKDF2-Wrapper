# PBKDF2-Wrapper

[![Version](https://img.shields.io/cocoapods/v/PBKDF2-Wrapper.svg?style=flat)](http://cocoadocs.org/docsets/PBKDF2-Wrapper)
[![Platform](https://img.shields.io/cocoapods/p/PBKDF2-Wrapper.svg?style=flat)](http://cocoadocs.org/docsets/PBKDF2-Wrapper)
[![License](https://img.shields.io/cocoapods/l/PBKDF2-Wrapper.svg?style=flat)](http://cocoadocs.org/docsets/PBKDF2-Wrapper)

PBKDF2-Wrapper provides a very simple Objective-C interface for the [CommonCrypto](https://developer.apple.com/library/mac/documentation/security/conceptual/cryptoservices/GeneralPurposeCrypto/GeneralPurposeCrypto.html#//apple_ref/doc/uid/TP40011172-CH9-SW1) implementation of the [PBKDF2](http://blog.agilebits.com/2011/05/05/defending-against-crackers-peanut-butter-keeps-dogs-friendly-too/) algorithm.

## Usage

#### Derive Key
Derive an encryption key from a password. `PBKDF2Result` automatically handles creating a secure random salt, and calibrating the number of rounds to take approximately 100ms to derive the key.

```objective-c
NSString *password = ...;
PBKDF2Result *result = [[PBKDF2Result alloc] initWithPassword:password];
NSData *encryptionKey = result.derivedKey;
```

#### Save Configuration
Afterwards you can conveniently archive the configuration which includes information such the key length, salt, number of rounds, and the pseudo random function that was used when deriving the key.

```objective-c
[NSKeyedArchiver archiveRootObject:result.configuration
                            toFile:@"/path/to/file"];
```

#### Load Saved Configuration
Next launch you can grab the archived configuration file and use that when deriving the key.

```objective-c
PBKDF2Configuration *configuration = [NSKeyedUnarchiver unarchiveObjectWithFile:@"/path/to/file"];

NSString *password = ...;
PBKDF2Result *result = [[PBKDF2Result alloc] initWithPassword:password
                                                configuration:configuration];
NSData *encryptionKey = result.derivedKey;
```

#### Explicit Configuration Creation
In addition you can also explicitly create the configuration using a number of helpful initializers. Here is an example:

```objective-c
NSData *salt = ...;

[[PBKDF2Configuration alloc] initWithSalt:salt
                         derivedKeyLength:16
                                   rounds:20000
                     pseudoRandomFunction:PBKDF2PseudoRandomFunctionSHA256];
```

## Installation

1. Install via [CocoaPods](http://cocoapods.org/)
	
  ```ruby
  pod 'PBKDF2-Wrapper'
  ```

2. Import the public header

  ```objective-c
  #import <PBKDF2-Wrapper/PBKDF2-Wrapper.h>
  ```

##Requirements

- iOS 6.0
- OSX 10.8
- watchOS 2.0

## Tests

[![Build Status](https://travis-ci.org/joeymeyer/PBKDF2-Wrapper.svg?branch=master)](https://travis-ci.org/joeymeyer/PBKDF2-Wrapper)

To run tests pull down the repository and run the following commands:

```bash
$ bundle install
$ bundle exec rake test:prepare
$ bundle exec rake
```

## Creator

[Joey Meyer](http://www.joeymeyer.com)

## License

PBKDF2-Wrapper is available under the MIT license. See the LICENSE file for more info.
