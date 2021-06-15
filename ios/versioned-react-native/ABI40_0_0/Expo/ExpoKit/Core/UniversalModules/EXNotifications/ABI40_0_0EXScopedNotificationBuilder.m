// Copyright 2018-present 650 Industries. All rights reserved.

#import "ABI40_0_0EXScopedNotificationBuilder.h"

@interface ABI40_0_0EXScopedNotificationBuilder ()

@property (nonatomic, strong) NSString *experienceScopeKey;

@end

@implementation ABI40_0_0EXScopedNotificationBuilder

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }

  return self;
}

- (UNNotificationContent *)notificationContentFromRequest:(NSDictionary *)request
{
  UNMutableNotificationContent *content = [super notificationContentFromRequest:request];
  NSMutableDictionary *userInfo = [content.userInfo mutableCopy];
  if (!userInfo) {
    userInfo = [NSMutableDictionary dictionary];
  }
  userInfo[@"experienceId"] = _experienceScopeKey;
  userInfo[@"scopeKey"] = _experienceScopeKey;
  [content setUserInfo:userInfo];

  if (content.categoryIdentifier) {
    NSString *categoryIdentifier = [NSString stringWithFormat:@"%@-%@", _experienceScopeKey, content.categoryIdentifier];
    [content setCategoryIdentifier:categoryIdentifier];
  }

  return content;
}

@end
