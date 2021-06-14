// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<EXUpdates/EXUpdatesService.h>)

#import "EXUpdatesBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface EXUpdatesBinding ()

@property (nonatomic, strong) NSString *experienceScopeKey;
@property (nonatomic, weak) id<EXUpdatesBindingDelegate> updatesKernelService;
@property (nonatomic, weak) id<EXUpdatesDatabaseBindingDelegate> databaseKernelService;

@end

@implementation EXUpdatesBinding : EXUpdatesService

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey updatesKernelService:(id<EXUpdatesBindingDelegate>)updatesKernelService databaseKernelService:(id<EXUpdatesDatabaseBindingDelegate>)databaseKernelService
{
  if (self = [super init]) {
    _experienceScopeKey = experienceScopeKey;
    _updatesKernelService = updatesKernelService;
    _databaseKernelService = databaseKernelService;
  }
  return self;
}

- (EXUpdatesConfig *)config
{
  return [_updatesKernelService configForExperienceScopeKey:_experienceScopeKey];
}

- (EXUpdatesDatabase *)database
{
  return _databaseKernelService.database;
}

- (EXUpdatesSelectionPolicy *)selectionPolicy
{
  return [_updatesKernelService selectionPolicyForExperienceScopeKey:_experienceScopeKey];
}

- (NSURL *)directory
{
  return _databaseKernelService.updatesDirectory;
}

- (nullable EXUpdatesUpdate *)launchedUpdate
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

- (void)requestRelaunchWithCompletion:(EXUpdatesAppRelaunchCompletionBlock)completion
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
