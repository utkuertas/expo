// Copyright 2018-present 650 Industries. All rights reserved.

#import "EXScopedNotificationBuilder.h"
#import "EXScopedNotificationsUtils.h"

@interface EXScopedNotificationBuilder ()

@property (nonatomic, strong) NSString *experienceScopeKey;
@property (nonatomic, assign) BOOL isInExpoGo;

@end

@implementation EXScopedNotificationBuilder

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
                       andConstantsBinding:(EXConstantsBinding *)constantsBinding
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
    NSString *scopedCategoryIdentifier = [EXScopedNotificationsUtils scopedIdentifierFromId:content.categoryIdentifier
                                                                              forExperience:_experienceScopeKey];
    [content setCategoryIdentifier:scopedCategoryIdentifier];
  }
  
  return content;
}

@end
