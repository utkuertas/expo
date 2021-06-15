// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesService.h>)
#import <Foundation/Foundation.h>
#import <ABI39_0_0UMCore/ABI39_0_0UMInternalModule.h>
#import <ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesConfig.h>
#import <ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesDatabase.h>
#import <ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesSelectionPolicy.h>
#import <ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesService.h>
#import <ABI39_0_0EXUpdates/ABI39_0_0EXUpdatesUpdate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABI39_0_0EXUpdatesBindingDelegate

- (ABI39_0_0EXUpdatesConfig *)configForExperienceScopeKey:(NSString *)experienceScopeKey;
- (ABI39_0_0EXUpdatesSelectionPolicy *)selectionPolicyForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable ABI39_0_0EXUpdatesUpdate *)launchedUpdateForExperienceScopeKey:(NSString *)experienceScopeKey;
- (nullable NSDictionary *)assetFilesMapForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isUsingEmbeddedAssetsForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isStartedForExperienceScopeKey:(NSString *)experienceScopeKey;
- (BOOL)isEmergencyLaunchForExperienceScopeKey:(NSString *)experienceScopeKey;
- (void)requestRelaunchForExperienceScopeKey:(NSString *)experienceScopeKey withCompletion:(ABI39_0_0EXUpdatesAppRelaunchCompletionBlock)completion;

@end

@protocol ABI39_0_0EXUpdatesDatabaseBindingDelegate

@property (nonatomic, strong, readonly) NSURL *updatesDirectory;
@property (nonatomic, strong, readonly) ABI39_0_0EXUpdatesDatabase *database;

@end

@interface ABI39_0_0EXUpdatesBinding : ABI39_0_0EXUpdatesService <ABI39_0_0UMInternalModule>

- (instancetype)initWithExperienceScopeKey:(NSString *)experienceScopeKey updatesKernelService:(id<ABI39_0_0EXUpdatesBindingDelegate>)updatesKernelService databaseKernelService:(id<ABI39_0_0EXUpdatesDatabaseBindingDelegate>)databaseKernelService;

@end

NS_ASSUME_NONNULL_END

#endif
