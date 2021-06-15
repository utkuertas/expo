// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI41_0_0React/ABI41_0_0RCTEventEmitter.h>

@interface ABI41_0_0EXScopedEventEmitter : ABI41_0_0RCTEventEmitter

+ (NSString *)getExperienceScopeKeyFromEventEmitter:(id)eventEmitter;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
                     kernelServiceDelegate:(id)kernelServiceInstance
                                    params:(NSDictionary *)params NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
                    kernelServiceDelegates:(NSDictionary *)kernelServiceInstances
                                    params:(NSDictionary *)params NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSString *experienceScopeKey;

@end
