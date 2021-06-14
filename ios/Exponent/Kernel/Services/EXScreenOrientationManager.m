// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXAppViewController.h"
#import "EXKernel.h"
#import "EXKernelAppRegistry.h"
#import "EXScreenOrientationManager.h"

NSNotificationName kEXChangeForegroundTaskSupportedOrientationsNotification = @"EXChangeForegroundTaskSupportedOrientations";

@implementation EXScreenOrientationManager

- (instancetype)init
{
  if (self = [super init]) {
    _subscribedModules = [NSMapTable strongToWeakObjectsMapTable];
  }
  return self;
}

- (void)setSupportInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations forExperienceScopeKey:(nullable NSString *)scopeKey
{
  EXKernelAppRegistry *appRegistry = [EXKernel sharedInstance].appRegistry;
  EXKernelAppRecord *recordForId = [appRegistry newestRecordWithExperienceScopeKey:scopeKey];
  if (recordForId) {
    [recordForId.viewController setSupportedInterfaceOrientations:supportedInterfaceOrientations];
  }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForVisibleApp
{
  EXKernelAppRecord *visibleApp = [EXKernel sharedInstance].visibleApp;
  return [visibleApp.viewController supportedInterfaceOrientations];
}

- (void)handleScreenOrientationChange:(UITraitCollection *)traitCollection
{
  for(NSString *experienceScopeKey in _subscribedModules) {
    id<EXScreenOrientationListener> subscribedModule = [_subscribedModules objectForKey:experienceScopeKey];
    [subscribedModule handleScreenOrientationChange:traitCollection];
  }
}

- (UITraitCollection *)getTraitCollection
{
  EXKernelAppRecord *visibleApp = [EXKernel sharedInstance].visibleApp;
  return [visibleApp.viewController traitCollection];
}

#pragma mark - scoped module delegate

- (void)screenOrientationModule:(id)scopedOrientationModule
didChangeSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  [self setSupportInterfaceOrientations:supportedInterfaceOrientations forExperienceScopeKey:((EXScopedBridgeModule *)scopedOrientationModule).experienceScopeKey];
}


- (void)removeOrientationChangeListenerForExperienceScopeKey:(NSString *)experienceScopeKey
{
  [_subscribedModules removeObjectForKey:experienceScopeKey];
}

- (void)addOrientationChangeListenerForExperienceScopeKey:(NSString *)experienceScopeKey subscriberModule:(id)subscriberModule
{
  [_subscribedModules setObject:subscriberModule forKey:experienceScopeKey];
}

@end
