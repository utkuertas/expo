// Copyright 2021-present 650 Industries. All rights reserved.

#import <EXNotifications/EXNotificationsDelegate.h>
#import <EXNotifications/EXNotificationCategoriesModule.h>

@interface EXScopedNotificationCategoryMigrator : NSObject <EXNotificationsDelegate>

+ (void)unscopeLegacyCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId;
+ (void)migrateLegacyScopedCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                                                                  experienceScopeKey:(NSString *)experienceScopeKey;

@end
