// Copyright 2019-present 650 Industries. All rights reserved.

#if __has_include(<UMReactNativeAdapter/EXPermissionsService.h>)
#import <UIKit/UIKit.h>
#import <UMReactNativeAdapter/EXPermissionsService.h>
#import "EXConstantsBinding.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EXPermissionsScopedModuleDelegate

- (EXPermissionStatus)getPermission:(NSString *)permissionType forExperience:(NSString *)experienceScopeKey;
- (BOOL)savePermission:(NSDictionary *)permission ofType:(NSString *)type forExperience:(NSString *)experienceScopeKey;

@end

@interface EXScopedPermissions : EXPermissionsService

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey andConstantsBinding:(EXConstantsBinding *)constantsBinding;

@end

NS_ASSUME_NONNULL_END
#endif
