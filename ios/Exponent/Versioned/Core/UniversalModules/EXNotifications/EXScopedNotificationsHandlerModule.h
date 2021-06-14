// Copyright 2018-present 650 Industries. All rights reserved.

#if __has_include(<EXNotifications/EXNotificationsHandlerModule.h>)

#import <EXNotifications/EXNotificationsHandlerModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface EXScopedNotificationsHandlerModule : EXNotificationsHandlerModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey;

@end

NS_ASSUME_NONNULL_END

#endif
