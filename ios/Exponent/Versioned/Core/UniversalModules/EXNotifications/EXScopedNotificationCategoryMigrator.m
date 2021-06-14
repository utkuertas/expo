// Copyright 2021-present 650 Industries. All rights reserved.

#import "EXScopedNotificationCategoryMigrator.h"
#import "EXScopedNotificationsUtils.h"

@implementation EXScopedNotificationCategoryMigrator

+ (void)migrateLegacyScopedCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId experienceScopeKey:(NSString *)experienceScopeKey
{
  [EXScopedNotificationCategoryMigrator renameLegacyCategoryIdentifiersForExperienceWithStableLegacyId:experienceStableLegacyId withBlock:^(UNNotificationCategory *oldCategory) {
    NSString *unscopedLegacyCategoryId = [EXScopedNotificationsUtils unscopedLegacyCategoryIdentifierWithId:oldCategory.identifier forExperienceStableLegacyId:experienceStableLegacyId];
    NSString *newCategoryId = [EXScopedNotificationsUtils scopedIdentifierFromId:unscopedLegacyCategoryId
                                                                   forExperience:experienceScopeKey];
    UNNotificationCategory *newCategory = [EXScopedNotificationCategoryMigrator createNewCategoryFrom:oldCategory withNewIdentifier:newCategoryId];
    return newCategory;
  }];
}

+ (void)unscopeLegacyCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
{
  [EXScopedNotificationCategoryMigrator renameLegacyCategoryIdentifiersForExperienceWithStableLegacyId:experienceStableLegacyId withBlock:^(UNNotificationCategory *oldCategory) {
    NSString *unscopedCategoryId = [EXScopedNotificationsUtils unscopedLegacyCategoryIdentifierWithId:oldCategory.identifier forExperienceStableLegacyId:experienceStableLegacyId];
    UNNotificationCategory *newCategory = [EXScopedNotificationCategoryMigrator createNewCategoryFrom:oldCategory withNewIdentifier:unscopedCategoryId];
    return newCategory;
  }];
}

+ (void)renameLegacyCategoryIdentifiersForExperienceWithStableLegacyId:(NSString *)experienceStableLegacyId withBlock:(UNNotificationCategory *(^)(UNNotificationCategory *category))renameCategoryBlock
{
  [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> *categories) {
    NSMutableSet<UNNotificationCategory *> *newCategories = [categories mutableCopy];
    BOOL didChangeCategories = NO;
    for (UNNotificationCategory *previousCategory in categories) {
      if ([EXScopedNotificationsUtils isLegacyCategoryId:previousCategory.identifier scopedByExperienceStableLegacyId:experienceStableLegacyId]) {
        UNNotificationCategory *newCategory = renameCategoryBlock(previousCategory);
        [newCategories removeObject:previousCategory];
        [newCategories addObject:newCategory];
        didChangeCategories = YES;
      }
    }
    if (didChangeCategories) {
      [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:newCategories];
    }
  }];
}

+ (UNNotificationCategory *)createNewCategoryFrom:(UNNotificationCategory *)originalCategory withNewIdentifier:(NSString *)newCategoryId
{
  if (@available(iOS 12, *)) {
    return [UNNotificationCategory categoryWithIdentifier:newCategoryId
                                                  actions:originalCategory.actions
                                        intentIdentifiers:originalCategory.intentIdentifiers
                            hiddenPreviewsBodyPlaceholder:originalCategory.hiddenPreviewsBodyPlaceholder
                                    categorySummaryFormat:originalCategory.categorySummaryFormat
                                                  options:originalCategory.options];
  } else if (@available(iOS 11, *)) {
    return [UNNotificationCategory categoryWithIdentifier:newCategoryId
                                                  actions:originalCategory.actions
                                        intentIdentifiers:originalCategory.intentIdentifiers
                            hiddenPreviewsBodyPlaceholder:originalCategory.hiddenPreviewsBodyPlaceholder
                                                  options:originalCategory.options];
  } else {
    return [UNNotificationCategory categoryWithIdentifier:newCategoryId
                                                  actions:originalCategory.actions
                                        intentIdentifiers:originalCategory.intentIdentifiers
                                                  options:originalCategory.options];
  }
}

@end
