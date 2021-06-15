// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesService.h>)
#import <Foundation/Foundation.h>
#import <ABI41_0_0UMCore/ABI41_0_0UMInternalModule.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesConfig.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesDatabase.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesSelectionPolicy.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesService.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesUpdate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABI41_0_0EXUpdatesBindingDelegate

- (ABI41_0_0EXUpdatesConfig *)configForExperienceScopeKey:(NSString *)experienceScopeKey;
- (ABI41_0_0EXUpdatesSelectionPolicy *)selectionPolicyForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable ABI41_0_0EXUpdatesUpdate *)launchedUpdateForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable NSDictionary *)assetFilesMapForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isUsingEmbeddedAssetsForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isStartedForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isEmergencyLaunchForExperienceScopeKey:(NSString *)experienceScopeKey;
- (void)requestRelaunchForExperienceScopeKey:(NSString *)experienceScopeKey withCompletion:(ABI41_0_0EXUpdatesAppRelaunchCompletionBlock)completion;

@end

@protocol ABI41_0_0EXUpdatesDatabaseBindingDelegate

@property (nonatomic, strong, readonly) NSURL *updatesDirectory;
@property (nonatomic, strong, readonly) ABI41_0_0EXUpdatesDatabase *database;

@end

@interface ABI41_0_0EXUpdatesBinding : ABI41_0_0EXUpdatesService <ABI41_0_0UMInternalModule>

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey updatesKernelService:(id<ABI41_0_0EXUpdatesBindingDelegate>)updatesKernelService databaseKernelService:(id<ABI41_0_0EXUpdatesDatabaseBindingDelegate>)databaseKernelService;

@end

NS_ASSUME_NONNULL_END

#endif
