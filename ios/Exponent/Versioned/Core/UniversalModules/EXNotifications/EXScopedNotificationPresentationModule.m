// Copyright 2018-present 650 Industries. All rights reserved.

#import "EXScopedNotificationPresentationModule.h"
#import "EXScopedNotificationsUtils.h"
#import "EXScopedNotificationSerializer.h"
#import "EXScopedNotificationsUtils.h"

@interface EXScopedNotificationPresentationModule ()

@property (nonatomic, strong) NSString *experienceScopeKey;

@end

@implementation EXScopedNotificationPresentationModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }
  
  return self;
}

- (NSArray * _Nonnull)serializeNotifications:(NSArray<UNNotification *> * _Nonnull)notifications
{
  NSMutableArray *serializedNotifications = [NSMutableArray new];
  for (UNNotification *notification in notifications) {
    if ([EXScopedNotificationsUtils shouldNotification:notification beHandledByExperience:_experienceScopeKey]) {
      [serializedNotifications addObject:[EXScopedNotificationSerializer serializedNotification:notification]];
    }
  }
  return serializedNotifications;
}

- (void)dismissNotificationWithIdentifier:(NSString *)identifier resolve:(UMPromiseResolveBlock)resolve reject:(UMPromiseRejectBlock)reject
{
  __block NSString *experienceScopeKey = _experienceScopeKey;
  [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
    for (UNNotification *notification in notifications) {
      if ([EXScopedNotificationsUtils shouldNotification:notification beHandledByExperience:experienceScopeKey]) {
        // Usually we would scope the input ID and then check equality, but remote notifications do not
        // have the scoping prefix, so instead let's remove the scope if there is one, then check for
        // equality against the input
        NSString *unscopedIdentifier = [EXScopedNotificationsUtils getScopeAndIdentifierFromScopedIdentifier:notification.request.identifier].identifier;
        if ([unscopedIdentifier isEqualToString:identifier]) {
          [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[notification.request.identifier]];
        }
        break;
      }
    }
    resolve(nil);
  }];
}

- (void)dismissAllNotificationsWithResolver:(UMPromiseResolveBlock)resolve reject:(UMPromiseRejectBlock)reject
{
  __block NSString *experienceScopeKey = _experienceScopeKey;
  [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
    NSMutableArray<NSString *> *toDismiss = [NSMutableArray new];
    for (UNNotification *notification in notifications) {
      if ([EXScopedNotificationsUtils shouldNotification:notification beHandledByExperience:experienceScopeKey]) {
        [toDismiss addObject:notification.request.identifier];
      }
    }
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:toDismiss];
    resolve(nil);
  }];
}

@end
