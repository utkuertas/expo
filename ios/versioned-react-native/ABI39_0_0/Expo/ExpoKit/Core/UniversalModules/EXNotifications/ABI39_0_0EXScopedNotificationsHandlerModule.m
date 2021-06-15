// Copyright 2018-present 650 Industries. All rights reserved.

#import "ABI39_0_0EXScopedNotificationsHandlerModule.h"
#import "ABI39_0_0EXScopedNotificationsUtils.h"

@interface ABI39_0_0EXScopedNotificationsHandlerModule ()

@property (nonatomic, strong) NSString *experienceScopeKey;

@end

@implementation ABI39_0_0EXScopedNotificationsHandlerModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }

  return self;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
  if ([ABI39_0_0EXScopedNotificationsUtils shouldNotification:notification beHandledByExperience:_experienceScopeKey]) {
    [super userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
  }
}

@end
