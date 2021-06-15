// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesService.h>)

#import "ABI40_0_0EXUpdatesBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABI40_0_0EXUpdatesBinding ()

@property (nonatomic, strong) NSString *experienceScopeKey;
@property (nonatomic, weak) id<ABI40_0_0EXUpdatesBindingDelegate> updatesKernelService;
@property (nonatomic, weak) id<ABI40_0_0EXUpdatesDatabaseBindingDelegate> databaseKernelService;

@end

@implementation ABI40_0_0EXUpdatesBinding : ABI40_0_0EXUpdatesService

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey updatesKernelService:(id<ABI40_0_0EXUpdatesBindingDelegate>)updatesKernelService databaseKernelService:(id<ABI40_0_0EXUpdatesDatabaseBindingDelegate>)databaseKernelService
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
    _updatesKernelService = updatesKernelService;
    _databaseKernelService = databaseKernelService;
  }
  return self;
}

- (ABI40_0_0EXUpdatesConfig *)config
{
  return [_updatesKernelService configForExperienceScopeKey:_experienceScopeKey];
}

- (ABI40_0_0EXUpdatesDatabase *)database
{
  return _databaseKernelService.database;
}

- (ABI40_0_0EXUpdatesSelectionPolicy *)selectionPolicy
{
  return [_updatesKernelService selectionPolicyForExperienceScopeKey:_experienceScopeKey];
}

- (NSURL *)directory
{
  return _databaseKernelService.updatesDirectory;
}

- (nullable ABI40_0_0EXUpdatesUpdate *)launchedUpdate
{
  return [_updatesKernelService launchedUpdateForExperienceScopeKey:_experienceScopeKey];
}

- (nullable NSDictionary *)assetFilesMap
{
  return [_updatesKernelService assetFilesMapForExperienceScopeKey:_experienceScopeKey];
}

- (BOOL)isUsingEmbeddedAssets
{
  return [_updatesKernelService isUsingEmbeddedAssetsForExperienceScopeKey:_experienceScopeKey];
}

- (BOOL)isStarted
{
  return [_updatesKernelService isStartedForExperienceScopeKey:_experienceScopeKey];
}

- (BOOL)isEmergencyLaunch
{
  return [_updatesKernelService isEmergencyLaunchForExperienceScopeKey:_experienceScopeKey];
}

- (BOOL)canRelaunch
{
  return YES;
}

- (void)requestRelaunchWithCompletion:(ABI40_0_0EXUpdatesAppRelaunchCompletionBlock)completion
{
  return [_updatesKernelService requestRelaunchForExperienceScopeKey:_experienceScopeKey withCompletion:completion];
}

- (void)resetSelectionPolicy
{
  // no-op in managed
}

@end

NS_ASSUME_NONNULL_END

#endif
