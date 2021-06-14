// Copyright 2015-present 650 Industries. All rights reserved.

#import <React/RCTEventEmitter.h>

@interface EXScopedEventEmitter : RCTEventEmitter

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
