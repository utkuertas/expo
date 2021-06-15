// Copyright 2018-present 650 Industries. All rights reserved.

#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSString *scopeKey;
    NSString *identifier;
} ScopedIdentifierComponents;

@interface ABI41_0_0EXScopedNotificationsUtils : NSObject

+ (BOOL)shouldNotificationRequest:(UNNotificationRequest *)request beHandledByExperience:(NSString *)experienceScopeKey;

+ (BOOL)shouldNotification:(UNNotification *)notification beHandledByExperience:(NSString *)experienceScopeKey;

+ (NSString *)scopedIdentifierFromId:(NSString *)unscopedId forExperience:(NSString *)experienceScopeKey;

+ (BOOL)isId:(NSString *)identifier scopedByExperience:(NSString *)experienceScopeKey;

+ (ScopedIdentifierComponents)getScopeAndIdentifierFromScopedIdentifier:(NSString *)scopedIdentifier;

+ (BOOL)isLegacyCategoryId:(NSString *)scopedCategoryId scopedByExperienceStableLegacyId:(NSString *)experienceStableLegacyId;

+ (NSString *)unscopedLegacyCategoryIdentifierWithId:(NSString *)scopedCategoryId
                         forExperienceStableLegacyId:(NSString *)experienceStableLegacyId;

@end

NS_ASSUME_NONNULL_END
