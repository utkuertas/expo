// Copyright © 2019-present 650 Industries. All rights reserved.

#if __has_include(<ABI39_0_0EXSecureStore/ABI39_0_0EXSecureStore.h>)
#import "ABI39_0_0EXScopedSecureStore.h"

@interface ABI39_0_0EXSecureStore (Protected)

- (NSString *)validatedKey:(NSString *)key;

@end

@interface ABI39_0_0EXScopedSecureStore ()

@property (strong, nonatomic) NSString *experienceScopeKey;

@end

@implementation ABI39_0_0EXScopedSecureStore

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }
  return self;
}

- (NSString *)validatedKey:(NSString *)key {
  if (![super validatedKey:key]) {
    return nil;
  }

  return [NSString stringWithFormat:@"%@-%@", _experienceScopeKey, key];
}

@end
#endif
