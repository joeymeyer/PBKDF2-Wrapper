//
//  PBKDF2ResultTests.m
//  PBKDF2-Wrapper Tests
//
//  Created by Joey Meyer on 4/21/14.
//
//

#import <XCTest/XCTest.h>

NSData *NSDataFromHexString(NSString *hexString) {
  hexString = [hexString lowercaseString];
  
  NSMutableData *data= [[NSMutableData alloc] init];
  
  unsigned char wholeByte;
  char byteCharacters[3] = {'\0','\0','\0'};
  
  int i = 0;
  while (i < hexString.length - 1) {
    char c = [hexString characterAtIndex:i++];
    if (c < '0' || (c > '9' && c < 'a') || c > 'f')
      continue;
    byteCharacters[0] = c;
    byteCharacters[1] = [hexString characterAtIndex:i++];
    wholeByte = strtol(byteCharacters, NULL, 16);
    [data appendBytes:&wholeByte length:1];
  }
  
  return data;
}

@interface PBKDF2ResultTests : XCTestCase

@property(nonatomic,strong) PBKDF2Result *result;

@end

@implementation PBKDF2ResultTests

#pragma mark - Setup

- (void)setUp {
  [super setUp];
  
  self.result = nil;
}

#pragma mark - Tests

- (void)testGeneratedConfigurationRunsInDefaultEstimatedDelayTime {
  self.result = [[PBKDF2Result alloc] initWithPassword:@"passw0rd"];
  
  NSDate *start = [NSDate date];
  [self.result calculateDerivedKey];
  NSDate *end = [NSDate date];
  
  double delay = [end timeIntervalSinceDate:start] * 1000.0;
  
  EXP_expect(delay).to.beCloseToWithin(PBKDF2DefaultDelayInMilliseconds, 25);
}

- (void)testGeneratedConfigurationRunsInLongEstimatedDelayTime {
  NSString *password = @"passw0rd";
  
  PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithPasswordLength:password.length
                                                                          derivedKeyLength:PBKDF2DefaultDerivedKeyLength
                                                                                saltLength:PBKDF2DefaultSaltLength
                                                                      pseudoRandomFunction:PBKDF2DefaultPseudoRandomFunction
                                                              estimatedDelayInMilliseconds:1000];
  
  self.result = [[PBKDF2Result alloc] initWithPassword:password configuration:configuration];
  
  NSDate *start = [NSDate date];
  [self.result calculateDerivedKey];
  NSDate *end = [NSDate date];
  
  double delay = [end timeIntervalSinceDate:start] * 1000.0;
  
  EXP_expect(delay).to.beCloseToWithin(1000, 250);
}

- (void)testShouldCallCalculateDerivedKeyAutomaticallyWhenAccessingDerivedKeyForTheFirstTime {
  self.result = [[PBKDF2Result alloc] initWithPassword:@"passw0rd"];
  
  EXP_expect(self.result.derivedKey).toNot.beNil;
}

- (void)testShouldCalculateDerivedKeyOfCorrectLength {
  self.result = [[PBKDF2Result alloc] initWithPassword:@"passw0rd" derivedKeyLength:64];
  
  EXP_expect(self.result.derivedKey.length).to.equal(64);
}

- (void)testResultShouldDeriveCorrectKeyForEachPseudoRandomFunction {
  NSData *salt = [@"asalt" dataUsingEncoding:NSUTF8StringEncoding];
  
  NSArray *knownKeyInformationArray = @[@{@"PRF": @(PBKDF2PseudoRandomFunctionSHA1),
                                          @"key": @"88bf54b69949b887ec98db53d3dc7f9b23d48ffc0ee2ce3ca9a264a297c0669d"},
                                        @{@"PRF": @(PBKDF2PseudoRandomFunctionSHA224),
                                          @"key": @"d9d001195f5cefc7ee89815e9a1e6ea93ce9a03fcee98a6e6e9e3f02eec2a1f7"},
                                        @{@"PRF": @(PBKDF2PseudoRandomFunctionSHA256),
                                          @"key": @"cf34c0a6d88607190f4ffc592b2e6a601b6301fddfc975138912ac1e86489a6e"},
                                        @{@"PRF": @(PBKDF2PseudoRandomFunctionSHA384),
                                          @"key": @"663d6e3edf3a802316545373b1c268fb84a2c7f737c374c3fdd83267993fb747"},
                                        @{@"PRF": @(PBKDF2PseudoRandomFunctionSHA512),
                                          @"key": @"c8c2e1631c0922441e9152cfc790df39b3ce07a10a0b232e140b4d005ff9e3ec"}];
  
  [knownKeyInformationArray enumerateObjectsUsingBlock:^(NSDictionary *knownKeyInformation, NSUInteger idx, BOOL *stop) {
    PBKDF2PseudoRandomFunction pseudoRandomFunction = [knownKeyInformation[@"PRF"] unsignedIntegerValue];
    
    PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithSalt:salt
                                                                  derivedKeyLength:32
                                                                            rounds:1000
                                                              pseudoRandomFunction:pseudoRandomFunction];
    
    self.result = [[PBKDF2Result alloc] initWithPassword:@"passw0rd" configuration:configuration];
    
    NSData *knownDerivedKey = NSDataFromHexString(knownKeyInformation[@"key"]);
    
    EXP_expect(self.result.derivedKey).to.equal(knownDerivedKey);
  }];
}

- (void)testResultShouldDeriveCorrectKeyForVariableNumberOfRounds {
  NSData *salt = [@"asalt" dataUsingEncoding:NSUTF8StringEncoding];
  
  NSArray *knownKeyInformationArray = @[@{@"rounds": @(1),
                                          @"key": @"8eff92f06898164f9c885b694419ba693b65282239191a2b3d4e50c41dd14d9e"},
                                        @{@"rounds": @(100),
                                          @"key": @"698175f03a030c8422c96f6ca70d5ac0f52459ae7848645c859a3944b083807d"},
                                        @{@"rounds": @(188),
                                          @"key": @"1be77412961e2e3e0079525fd98c48a7ca7aef99595dfc1728c01fbe92d626c1"},
                                        @{@"rounds": @(4096),
                                          @"key": @"6028054d056f5c797c6c85b3c6eb141f9592fd2988127c70ff3cfe68b74b8332"},
                                        @{@"rounds": @(10000),
                                          @"key": @"5e2ba2996b6df5864a0a57b6acaf0d4a926ef1a1a56a958cd571ed326d97b8bb"}];
  
  [knownKeyInformationArray enumerateObjectsUsingBlock:^(NSDictionary *knownKeyInformation, NSUInteger idx, BOOL *stop) {
    uint32_t rounds = (uint32_t)[knownKeyInformation[@"rounds"] unsignedIntegerValue];
    
    PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithSalt:salt
                                                                  derivedKeyLength:32
                                                                            rounds:rounds
                                                              pseudoRandomFunction:PBKDF2PseudoRandomFunctionSHA1];
    
    self.result = [[PBKDF2Result alloc] initWithPassword:@"passw0rd" configuration:configuration];
    
    NSData *knownDerivedKey = NSDataFromHexString(knownKeyInformation[@"key"]);
    
    EXP_expect(self.result.derivedKey).to.equal(knownDerivedKey);
  }];
}

- (void)testResultShouldDeriveCorrectKeyForVariableSalts {
  NSArray *knownKeyInformationArray = @[@{@"salt": @"abc",
                                          @"key": @"1d041a244e0f4e4f332bbea80117c366d45f4f66279eacfef9ae5987b73bd566"},
                                        @{@"salt": @"this is a salt",
                                          @"key": @"b62d4c1b923703beba776ee502a786a8e9a5bf95490d134cfae1047271b33ffe"},
                                        @{@"salt": @"another great salt",
                                          @"key": @"d487dbabeee0f307983ee2f28b53cdf8028cb140253a13932f98aae574dd9d18"},
                                        @{@"salt": @"123",
                                          @"key": @"420ee37ed9d36266d3c6fe3f84ac4010436c30de4a9394c01dbeba580fe84948"},
                                        @{@"salt": @"SALT",
                                          @"key": @"cc780bc040852cbf6fadc7349844d08878038824ac88f40efdf2c3073ee20201"}];
  
  [knownKeyInformationArray enumerateObjectsUsingBlock:^(NSDictionary *knownKeyInformation, NSUInteger idx, BOOL *stop) {
    NSData *salt = [knownKeyInformation[@"salt"] dataUsingEncoding:NSUTF8StringEncoding];
    
    PBKDF2Configuration *configuration = [[PBKDF2Configuration alloc] initWithSalt:salt
                                                                  derivedKeyLength:32
                                                                            rounds:1000
                                                              pseudoRandomFunction:PBKDF2PseudoRandomFunctionSHA1];
    
    self.result = [[PBKDF2Result alloc] initWithPassword:@"passw0rd" configuration:configuration];
    
    NSData *knownDerivedKey = NSDataFromHexString(knownKeyInformation[@"key"]);
    
    EXP_expect(self.result.derivedKey).to.equal(knownDerivedKey);
  }];
}

@end
