// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesService.h>)
#import <Foundation/Foundation.h>
#import <ABI40_0_0UMCore/ABI40_0_0UMInternalModule.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesConfig.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesDatabase.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesSelectionPolicy.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesService.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesUpdate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABI40_0_0EXUpdatesBindingDelegate

- (ABI40_0_0EXUpdatesConfig *)configForExperienceScopeKey:(NSString *)experienceScopeKey;
- (ABI40_0_0EXUpdatesSelectionPolicy *)selectionPolicyForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable ABI40_0_0EXUpdatesUpdate *)launchedUpdateForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable NSDictionary *)assetFilesMapForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isUsingEmbeddedAssetsForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isStartedForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isEmergencyLaunchForExperienceScopeKey:(NSString *)experienceScopeKey;
- (void)requestRelaunchForExperienceScopeKey:(NSString *)experienceScopeKey withCompletion:(ABI40_0_0EXUpdatesAppRelaunchCompletionBlock)completion;

@end

@protocol ABI40_0_0EXUpdatesDatabaseBindingDelegate

@property (nonatomic, strong, readonly) NSURL *updatesDirectory;
@property (nonatomic, strong, readonly) ABI40_0_0EXUpdatesDatabase *database;

@end

@interface ABI40_0_0EXUpdatesBinding : ABI40_0_0EXUpdatesService <ABI40_0_0UMInternalModule>

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey updatesKernelService:(id<ABI40_0_0EXUpdatesBindingDelegate>)updatesKernelService databaseKernelService:(id<ABI40_0_0EXUpdatesDatabaseBindingDelegate>)databaseKernelService;

@end

NS_ASSUME_NONNULL_END

#endif
