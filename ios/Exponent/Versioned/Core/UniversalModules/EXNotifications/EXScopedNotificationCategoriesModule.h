// Copyright 2018-present 650 Industries. All rights reserved.

#if __has_include(<EXNotifications/EXNotificationCategoriesModule.h>)

#import <EXNotifications/EXNotificationCategoriesModule.h>
#import "EXConstantsBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface EXScopedNotificationCategoriesModule : EXNotificationCategoriesModule

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey
                       andConstantsBinding:(EXConstantsBinding *)constantsBinding;

+ (void)maybeMigrateLegacyCategoryIdentifiersForProjectWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                                                                 experienceScopeKey:(NSString *)experienceScopeKey
                                                                         isInExpoGo:(BOOL)isInExpoGo;

@end

NS_ASSUME_NONNULL_END

#endif
