// Copyright 2021-present 650 Industries. All rights reserved.

#import <EXNotifications/EXNotificationsDelegate.h>
#import <EXNotifications/EXNotificationCategoriesModule.h>

@interface EXScopedNotificationCategoryMigrator : NSObject <EXNotificationsDelegate>

+ (void)unscopeLegacyCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                                                            experienceScopeKey:(NSString *)experienceScopeKey;
+ (void)migrateLegacyScopedCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId;

@end
