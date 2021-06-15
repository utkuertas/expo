// Copyright 2015-present 650 Industries. All rights reserved.

#import "ABI40_0_0EXScopedBridgeModule.h"

@implementation ABI40_0_0EXScopedBridgeModule

+ (NSString *)moduleName
{
  NSAssert(NO, @"ABI40_0_0EXScopedBridgeModule is abstract, you should only export subclasses to the bridge.");
  return @"ExponentScopedBridgeModule";
}

- (instancetype)initWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                              experienceScopeKey:(NSString *)experienceScopeKey
                           kernelServiceDelegate:(id)kernelServiceInstance
                                          params:(NSDictionary *)params
{
  if (self = [super init]) {
    _experienceStableLegacyId = experienceStableLegacyId;
    _experienceScopeKey = experienceScopeKey;
  }
  return self;
}

- (instancetype)initWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                              experienceScopeKey:(NSString *)experienceScopeKey
                          kernelServiceDelegates:(NSDictionary *)kernelServiceInstances
                                          params:(NSDictionary *)params
{
  if (self = [super init]) {
    _experienceStableLegacyId = experienceStableLegacyId;
    _experienceScopeKey = experienceScopeKey;
  }
  return self;
}

@end
