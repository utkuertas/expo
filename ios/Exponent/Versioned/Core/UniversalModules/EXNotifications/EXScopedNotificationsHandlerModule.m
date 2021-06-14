// Copyright 2018-present 650 Industries. All rights reserved.

#import "EXScopedNotificationsHandlerModule.h"
#import "EXScopedNotificationsUtils.h"

@interface EXScopedNotificationsHandlerModule ()

@property (nonatomic, strong) NSString *experienceScopeKey;

@end

@implementation EXScopedNotificationsHandlerModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }
  
  return self;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
  if ([EXScopedNotificationsUtils shouldNotification:notification beHandledByExperience:_experienceScopeKey]) {
    [super userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
  }
}

@end
