//
//  PBKDF2ConfigurationTests.m
//  PBKDF2-Wrapper Tests
//
//  Created by Joey Meyer on 4/21/14.
//
//

#import <XCTest/XCTest.h>

@interface PBKDF2ConfigurationTests : XCTestCase

@property(nonatomic,strong) PBKDF2Configuration *configuration;

@end

@implementation PBKDF2ConfigurationTests

#pragma mark - Setup

- (void)setUp {
  [super setUp];
  
  self.configuration = nil;
}

#pragma mark - Tests

- (void)testVariablePasswordLengthConfigurationInitializer {
  self.configuration = [[PBKDF2Configuration alloc] initWithPasswordLength:12
                                                          derivedKeyLength:64
                                                                saltLength:128
                                                      pseudoRandomFunction:PBKDF2PseudoRandomFunctionSHA256
                                              estimatedDelayInMilliseconds:PBKDF2DefaultDelayInMilliseconds];
  
  EXP_expect(self.configuration.derivedKeyLength).to.equal(64);
  EXP_expect(self.configuration.salt).toNot.beNil;
  EXP_expect(self.configuration.salt.length).to.equal(128);
  EXP_expect(self.configuration.pseudoRandomFunction).to.equal(PBKDF2PseudoRandomFunctionSHA256);
}

- (void)testVariableSaltDefinedRoundsConfigurationInitializer {
  self.configuration = [[PBKDF2Configuration alloc] initWithDerivedKeyLength:PBKDF2DefaultDerivedKeyLength
                                                                  saltLength:32
                                                                      rounds:20000
                                                        pseudoRandomFunction:PBKDF2PseudoRandomFunctionSHA384];
  
  EXP_expect(self.configuration.derivedKeyLength).to.equal(PBKDF2DefaultDerivedKeyLength);
  EXP_expect(self.configuration.salt).toNot.beNil;
  EXP_expect(self.configuration.salt.length).to.equal(32);
  EXP_expect(self.configuration.rounds).to.equal(20000);
  EXP_expect(self.configuration.pseudoRandomFunction).to.equal(PBKDF2PseudoRandomFunctionSHA384);
}

- (void)testExplicitConfigurationInitializer {
  NSData *salt = [@"asalt" dataUsingEncoding:NSUTF8StringEncoding];
  
  self.configuration = [[PBKDF2Configuration alloc] initWithSalt:salt
                                                derivedKeyLength:128
                                                          rounds:4000
                                            pseudoRandomFunction:PBKDF2PseudoRandomFunctionSHA512];
  
  EXP_expect(self.configuration.derivedKeyLength).to.equal(128);
  EXP_expect(self.configuration.salt).to.equal(salt);
  EXP_expect(self.configuration.rounds).to.equal(4000);
  EXP_expect(self.configuration.pseudoRandomFunction).to.equal(PBKDF2PseudoRandomFunctionSHA512);
}

@end
