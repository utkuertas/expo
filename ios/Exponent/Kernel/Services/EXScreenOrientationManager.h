// Copyright 2015-present 650 Industries. All rights reserved.

// TODO: Remove once sdk 37 is phased out
@protocol EXScreenOrientationScopedModuleDelegate

- (void)screenOrientationModule:(nonnull id)scopedOrientationModule
didChangeSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations;

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForVisibleApp;

- (void)removeOrientationChangeListenerForExperienceScopeKey:(nonnull NSString *)experienceScopeKey;

- (void)addOrientationChangeListenerForExperienceScopeKey:(nonnull NSString *)experienceScopeKey subscriberModule:(nonnull id)subscriberModule;

- (nullable UITraitCollection *)getTraitCollection;

@end

@protocol EXScreenOrientationListener

- (void)handleScreenOrientationChange:(nullable UITraitCollection *)traitCollection;

@end

@interface EXScreenOrientationManager : NSObject <EXScreenOrientationScopedModuleDelegate>

@property (nonatomic, strong) NSMapTable<NSString *, id> *__nonnull subscribedModules;

@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientationsForVisibleApp;

- (void)setSupportInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations forExperienceScopeKey:(nullable NSString *)scopeKey;

- (void)handleScreenOrientationChange:(nullable UITraitCollection *)traitCollection;

@end
