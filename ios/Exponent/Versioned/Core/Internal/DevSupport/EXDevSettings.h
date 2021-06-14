// Copyright 2015-present 650 Industries. All rights reserved.

#import <React/RCTDevSettings.h>

@interface EXDevSettings : RCTDevSettings

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
                             isDevelopment:(BOOL)isDevelopment NS_DESIGNATED_INITIALIZER;

@end
