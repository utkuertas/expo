// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<EXUpdates/EXUpdatesService.h>)
#import <Foundation/Foundation.h>
#import <UMCore/UMInternalModule.h>
#import <EXUpdates/EXUpdatesConfig.h>
#import <EXUpdates/EXUpdatesDatabase.h>
#import <EXUpdates/EXUpdatesSelectionPolicy.h>
#import <EXUpdates/EXUpdatesService.h>
#import <EXUpdates/EXUpdatesUpdate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EXUpdatesBindingDelegate

- (EXUpdatesConfig *)configForExperienceScopeKey:(NSString *)experienceScopeKey;
- (EXUpdatesSelectionPolicy *)selectionPolicyForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable EXUpdatesUpdate *)launchedUpdateForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable NSDictionary *)assetFilesMapForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isUsingEmbeddedAssetsForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isStartedForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isEmergencyLaunchForExperienceScopeKey:(NSString *)experienceScopeKey;
- (void)requestRelaunchForExperienceScopeKey:(NSString *)experienceScopeKey withCompletion:(EXUpdatesAppRelaunchCompletionBlock)completion;

@end

@protocol EXUpdatesDatabaseBindingDelegate

@property (nonatomic, strong, readonly) NSURL *updatesDirectory;
@property (nonatomic, strong, readonly) EXUpdatesDatabase *database;

@end

@interface EXUpdatesBinding : EXUpdatesService <UMInternalModule>

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey updatesKernelService:(id<EXUpdatesBindingDelegate>)updatesKernelService databaseKernelService:(id<EXUpdatesDatabaseBindingDelegate>)databaseKernelService;

@end

NS_ASSUME_NONNULL_END

#endif
