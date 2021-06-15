// Copyright 2018-present 650 Industries. All rights reserved.

#import "ABI41_0_0EXScopedNotificationBuilder.h"
#import "ABI41_0_0EXScopedNotificationsUtils.h"

@interface ABI41_0_0EXScopedNotificationBuilder ()

@property (nonatomic, strong) NSString *experienceScopeKey;
@property (nonatomic, assign) BOOL isInExpoGo;

@end

@implementation ABI41_0_0EXScopedNotificationBuilder

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
                 andConstantsBinding:(ABI41_0_0EXConstantsBinding *)constantsBinding
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
    _isInExpoGo = [@"expo" isEqualToString:constantsBinding.appOwnership];
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

  if (content.categoryIdentifier && _isInExpoGo) {
    NSString *scopedCategoryIdentifier = [ABI41_0_0EXScopedNotificationsUtils scopedIdentifierFromId:content.categoryIdentifier
                                                                              forExperience:_experienceScopeKey];
    [content setCategoryIdentifier:scopedCategoryIdentifier];
  }

  return content;
}

@end
