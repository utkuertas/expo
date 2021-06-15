// Copyright 2018-present 650 Industries. All rights reserved.

#import "ABI41_0_0EXScopedNotificationSchedulerModule.h"
#import "ABI41_0_0EXScopedNotificationsUtils.h"
#import "ABI41_0_0EXScopedNotificationSerializer.h"
#import "ABI41_0_0EXScopedNotificationsUtils.h"

@interface ABI41_0_0EXScopedNotificationSchedulerModule ()

@property (nonatomic, strong) NSString *experienceScopeKey;

@end

@implementation ABI41_0_0EXScopedNotificationSchedulerModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
  }

  return self;
}

- (UNNotificationRequest *)buildNotificationRequestWithIdentifier:(NSString *)identifier
                                                          content:(NSDictionary *)contentInput
                                                          trigger:(NSDictionary *)triggerInput
{
  NSString *scopedIdentifier = [ABI41_0_0EXScopedNotificationsUtils scopedIdentifierFromId:identifier
                                                                    forExperience:_experienceScopeKey];
  return [super buildNotificationRequestWithIdentifier:scopedIdentifier content:contentInput trigger:triggerInput];
}

- (NSArray * _Nonnull)serializeNotificationRequests:(NSArray<UNNotificationRequest *> * _Nonnull) requests;
{
  NSMutableArray *serializedRequests = [NSMutableArray new];
  for (UNNotificationRequest *request in requests) {
    if ([ABI41_0_0EXScopedNotificationsUtils isId:request.identifier scopedByExperience:_experienceScopeKey]) {
      [serializedRequests addObject:[ABI41_0_0EXScopedNotificationSerializer serializedNotificationRequest:request]];
    }
  }
  return serializedRequests;
}


- (void)cancelNotification:(NSString *)identifier resolve:(ABI41_0_0UMPromiseResolveBlock)resolve rejecting:(ABI41_0_0UMPromiseRejectBlock)reject
{
  NSString *scopedIdentifier = [ABI41_0_0EXScopedNotificationsUtils scopedIdentifierFromId:identifier
                                                                    forExperience:_experienceScopeKey];
  [super cancelNotification:scopedIdentifier resolve:resolve rejecting:reject];
}

- (void)cancelAllNotificationsWithResolver:(ABI41_0_0UMPromiseResolveBlock)resolve rejecting:(ABI41_0_0UMPromiseRejectBlock)reject
{
  __block NSString *experienceScopeKey = _experienceScopeKey;
  [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
    NSMutableArray<NSString *> *toRemove = [NSMutableArray new];
    for (UNNotificationRequest *request in requests) {
      if ([ABI41_0_0EXScopedNotificationsUtils isId:request.identifier scopedByExperience:experienceScopeKey]) {
        [toRemove addObject:request.identifier];
      }
    }
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:toRemove];
    resolve(nil);
  }];
}

@end
