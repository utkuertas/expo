// Copyright 2018-present 650 Industries. All rights reserved.

#import "ABI39_0_0EXScopedNotificationSchedulerModule.h"
#import "ABI39_0_0EXScopedNotificationsUtils.h"
#import "ABI39_0_0EXScopedNotificationSerializer.h"

@interface ABI39_0_0EXScopedNotificationSchedulerModule ()

@property (nonatomic, strong) NSString *experienceScopeKey;

@end

// TODO: (@lukmccall) experiences may break one another by trying to schedule notifications of the same identifier.
// See https://github.com/expo/expo/pull/8361#discussion_r429153429.
@implementation ABI39_0_0EXScopedNotificationSchedulerModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }

  return self;
}

- (NSArray * _Nonnull)serializeNotificationRequests:(NSArray<UNNotificationRequest *> * _Nonnull) requests;
{
  NSMutableArray *serializedRequests = [NSMutableArray new];
  for (UNNotificationRequest *request in requests) {
    if ([ABI39_0_0EXScopedNotificationsUtils shouldNotificationRequest:request beHandledByExperience:_experienceScopeKey]) {
      [serializedRequests addObject:[ABI39_0_0EXScopedNotificationSerializer serializedNotificationRequest:request]];
    }
  }
  return serializedRequests;
}

- (void)cancelNotification:(NSString *)identifier resolve:(ABI39_0_0UMPromiseResolveBlock)resolve rejecting:(ABI39_0_0UMPromiseRejectBlock)reject
{
  __block NSString *experienceScopeKey = _experienceScopeKey;
  [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
    for (UNNotificationRequest *request in requests) {
      if ([request.identifier isEqual:identifier]) {
        if ([ABI39_0_0EXScopedNotificationsUtils shouldNotificationRequest:request beHandledByExperience:experienceScopeKey]) {
          [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        }
        break;
      }
    }
    resolve(nil);
  }];
}

- (void)cancelAllNotificationsWithResolver:(ABI39_0_0UMPromiseResolveBlock)resolve rejecting:(ABI39_0_0UMPromiseRejectBlock)reject
{
  __block NSString *experienceScopeKey = _experienceScopeKey;
  [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
    NSMutableArray<NSString *> *toRemove = [NSMutableArray new];
    for (UNNotificationRequest *request in requests) {
      if ([ABI39_0_0EXScopedNotificationsUtils shouldNotificationRequest:request beHandledByExperience:experienceScopeKey]) {
        [toRemove addObject:request.identifier];
      }
    }
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:toRemove];
    resolve(nil);
  }];
}

@end
