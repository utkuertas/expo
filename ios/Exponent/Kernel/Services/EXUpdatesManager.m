// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXAppLoader+Updates.h"
#import "EXEnvironment.h"
#import "EXKernel.h"
#import "EXKernelAppRecord.h"
#import "EXReactAppManager.h"
#import "EXScopedModuleRegistry.h"
#import "EXUpdatesDatabaseManager.h"
#import "EXUpdatesManager.h"

#import <EXUpdates/EXUpdatesFileDownloader.h>
#import <EXUpdates/EXUpdatesRemoteAppLoader.h>

#import <React/RCTBridge.h>
#import <React/RCTUtils.h>

NSString * const EXUpdatesEventName = @"Expo.nativeUpdatesEvent";
NSString * const EXUpdatesErrorEventType = @"error";
NSString * const EXUpdatesUpdateAvailableEventType = @"updateAvailable";
NSString * const EXUpdatesNotAvailableEventType = @"noUpdateAvailable";

// legacy events
// TODO: remove once SDK 38 is phased out
NSString * const EXUpdatesEventNameLegacy = @"Exponent.nativeUpdatesEvent";
NSString * const EXUpdatesDownloadStartEventType = @"downloadStart";
NSString * const EXUpdatesDownloadProgressEventType = @"downloadProgress";
NSString * const EXUpdatesDownloadFinishedEventType = @"downloadFinished";

@interface EXUpdatesManager ()

@property (nonatomic, strong) EXAppLoader *manifestAppLoader;

@end

@implementation EXUpdatesManager

- (void)notifyApp:(EXKernelAppRecord *)appRecord
ofDownloadWithManifest:(EXUpdatesRawManifest * _Nullable)manifest
            isNew:(BOOL)isBundleNew
            error:(NSError * _Nullable)error;
{
  NSDictionary *body;
  NSDictionary *bodyLegacy;
  if (error) {
    body = @{
             @"type": EXUpdatesErrorEventType,
             @"message": error.localizedDescription
             };
  } else if (isBundleNew) {
    // prevent a crash, but this shouldn't ever happen
    NSDictionary *rawManifestJSON = manifest ? manifest.rawManifestJSON : @{};
    bodyLegacy = @{
                   @"type": EXUpdatesDownloadFinishedEventType,
                   @"manifest": rawManifestJSON
                   };
    body = @{
             @"type": EXUpdatesUpdateAvailableEventType,
             @"manifest": rawManifestJSON
             };
  } else {
    body = @{
             @"type": EXUpdatesNotAvailableEventType
             };
  }
  RCTBridge *bridge = appRecord.appManager.reactBridge;
  if (appRecord.status == kEXKernelAppRecordStatusRunning) {
    // for SDK 38 and below
    [bridge enqueueJSCall:@"RCTDeviceEventEmitter.emit" args:@[EXUpdatesEventNameLegacy, bodyLegacy ?: body]];
    // for SDK 39+
    [bridge enqueueJSCall:@"RCTDeviceEventEmitter.emit" args:@[EXUpdatesEventName, body]];
  }
}

# pragma mark - internal

- (EXAppLoader *)_appLoaderWithScopedModule:(id)scopedModule
{
  NSString *experienceScopeKey = ((EXScopedBridgeModule *)scopedModule).experienceScopeKey;
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey];
}

- (EXAppLoader *)_appLoaderWithExperienceScopeKey:(NSString *)experienceScopeKey
{
  EXKernelAppRecord *appRecord = [[EXKernel sharedInstance].appRegistry newestRecordWithExperienceScopeKey:experienceScopeKey];
  return appRecord.appLoader;
}

# pragma mark - EXUpdatesBindingDelegate

- (EXUpdatesConfig *)configForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey].config;
}

- (EXUpdatesSelectionPolicy *)selectionPolicyForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey].selectionPolicy;
}

- (nullable EXUpdatesUpdate *)launchedUpdateForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey].appLauncher.launchedUpdate;
}

- (nullable NSDictionary *)assetFilesMapForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey].appLauncher.assetFilesMap;
}

- (BOOL)isUsingEmbeddedAssetsForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return NO;
}

- (BOOL)isStartedForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey].appLauncher != nil;
}

- (BOOL)isEmergencyLaunchForExperienceScopeKey:(NSString *)experienceScopeKey
{
  return [self _appLoaderWithExperienceScopeKey:experienceScopeKey].isEmergencyLaunch;
}

- (void)requestRelaunchForExperienceScopeKey:(NSString *)experienceScopeKey withCompletion:(EXUpdatesAppRelaunchCompletionBlock)completion
{
  [[EXKernel sharedInstance] reloadAppFromCacheWithExperienceScopeKey:experienceScopeKey];
  completion(YES);
}

# pragma mark - EXUpdatesScopedModuleDelegate

- (void)updatesModuleDidSelectReload:(id)scopedModule
{
  NSString *experienceScopeKey = ((EXScopedBridgeModule *)scopedModule).experienceScopeKey;
  [[EXKernel sharedInstance] reloadAppWithExperienceScopeKey:experienceScopeKey];
}

- (void)updatesModuleDidSelectReloadFromCache:(id)scopedModule
{
  NSString *experienceScopeKey = ((EXScopedBridgeModule *)scopedModule).experienceScopeKey;
  [[EXKernel sharedInstance] reloadAppFromCacheWithExperienceScopeKey:experienceScopeKey];
}

- (void)updatesModule:(id)scopedModule
didRequestManifestWithCacheBehavior:(EXManifestCacheBehavior)cacheBehavior
              success:(void (^)(EXUpdatesRawManifest * _Nonnull))success
              failure:(void (^)(NSError * _Nonnull))failure
{
  if ([EXEnvironment sharedEnvironment].isDetached && ![EXEnvironment sharedEnvironment].areRemoteUpdatesEnabled) {
    failure(RCTErrorWithMessage(@"Remote updates are disabled in app.json"));
    return;
  }

  EXUpdatesDatabaseManager *databaseKernelService = [EXKernel sharedInstance].serviceRegistry.updatesDatabaseManager;
  EXAppLoader *appLoader = [self _appLoaderWithScopedModule:scopedModule];

  EXUpdatesFileDownloader *fileDownloader = [[EXUpdatesFileDownloader alloc] initWithUpdatesConfig:appLoader.config];
  [fileDownloader downloadManifestFromURL:appLoader.config.updateUrl
                             withDatabase:databaseKernelService.database
                             extraHeaders:nil
                             successBlock:^(EXUpdatesUpdate *update) {
    success(update.rawManifest);
  } errorBlock:^(NSError *error, NSURLResponse *response) {
    failure(error);
  }];
}


- (void)updatesModule:(id)scopedModule
didRequestBundleWithCompletionQueue:(dispatch_queue_t)completionQueue
                start:(void (^)(void))startBlock
              success:(void (^)(EXUpdatesRawManifest * _Nullable))success
              failure:(void (^)(NSError * _Nonnull))failure
{
  if ([EXEnvironment sharedEnvironment].isDetached && ![EXEnvironment sharedEnvironment].areRemoteUpdatesEnabled) {
    failure(RCTErrorWithMessage(@"Remote updates are disabled in app.json"));
    return;
  }

  EXUpdatesDatabaseManager *databaseKernelService = [EXKernel sharedInstance].serviceRegistry.updatesDatabaseManager;
  EXAppLoader *appLoader = [self _appLoaderWithScopedModule:scopedModule];

  EXUpdatesRemoteAppLoader *remoteAppLoader = [[EXUpdatesRemoteAppLoader alloc] initWithConfig:appLoader.config database:databaseKernelService.database directory:databaseKernelService.updatesDirectory completionQueue:completionQueue];
  [remoteAppLoader loadUpdateFromUrl:appLoader.config.updateUrl onManifest:^BOOL(EXUpdatesUpdate * _Nonnull update) {
    BOOL shouldLoad = [appLoader.selectionPolicy shouldLoadNewUpdate:update withLaunchedUpdate:appLoader.appLauncher.launchedUpdate filters:update.manifestFilters];
    if (shouldLoad) {
      startBlock();
    }
    return shouldLoad;
  } asset:^(EXUpdatesAsset *asset, NSUInteger successfulAssetCount, NSUInteger failedAssetCount, NSUInteger totalAssetCount) {
    // do nothing for now
  } success:^(EXUpdatesUpdate * _Nullable update) {
    if (update) {
      success(update.rawManifest);
    } else {
      success(nil);
    }
  } error:^(NSError * _Nonnull error) {
    failure(error);
  }];
}

@end
