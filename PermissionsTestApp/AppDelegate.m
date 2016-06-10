//
//  AppDelegate.m
//  PermissionsTestApp
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePermissionViewController.h"
#import "GrantedPermissionsViewController.h"

#import <ISHPermissionKit/ISHPermissionKit.h>
@import Accounts;

@interface AppDelegate ()<ISHPermissionsViewControllerDataSource>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWindow];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentPermissionsIfNeeded];
    });

    return YES;
}

+ (NSArray<NSNumber *> *)requiredPermissions {
    return @[
             @(ISHPermissionCategoryEvents),
             @(ISHPermissionCategoryReminders),
             @(ISHPermissionCategoryAddressBook),
             @(ISHPermissionCategoryLocationWhenInUse),
             @(ISHPermissionCategoryActivity),
             @(ISHPermissionCategoryMicrophone),
             @(ISHPermissionCategoryPhotoLibrary),
             @(ISHPermissionCategoryPhotoCamera),
             @(ISHPermissionCategoryNotificationLocal),
             @(ISHPermissionCategorySocialTwitter),
             @(ISHPermissionCategorySocialFacebook),
             ];
}

- (void)presentPermissionsIfNeeded {
    NSArray *permissions = [AppDelegate requiredPermissions];
    ISHPermissionsViewController *permissionsVC = [ISHPermissionsViewController permissionsViewControllerWithCategories:permissions dataSource:self];

    // use full screen persentation mode to allow viewWillAppear to be triggered on GrantedPermissionsViewController
    permissionsVC.modalPresentationStyle = UIModalPresentationFullScreen;

    if (permissionsVC) {
        [self.window.rootViewController presentViewController:permissionsVC animated:YES completion:nil];
    }
}

#pragma mark ISHPermissionsViewControllerDataSource

- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category {
    return [SamplePermissionViewController new];
}

- (void)permissionsViewController:(ISHPermissionsViewController *)vc didConfigureRequest:(ISHPermissionRequest *)request {
#ifdef __IPHONE_8_0
    if (request.permissionCategory == ISHPermissionCategoryNotificationLocal) {
        // the demo app only requests permissions for badges
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        ISHPermissionRequestNotificationsLocal *localNotesRequest = (ISHPermissionRequestNotificationsLocal *)([request isKindOfClass:[ISHPermissionRequestNotificationsLocal class]] ? request : nil);
        [localNotesRequest setNotificationSettings:setting];
    }
#endif

    if (request.permissionCategory == ISHPermissionCategorySocialFacebook) {
        ISHPermissionRequestAccount *accountRequest = (ISHPermissionRequestAccount *)([request isKindOfClass:[ISHPermissionRequestAccount class]] ? request : nil);

        NSDictionary *options = @{
                                  ACFacebookAppIdKey: @"YOUR-API-KEY",
                                  ACFacebookPermissionsKey: @[@"email", @"user_about_me"],
                                  ACFacebookAudienceKey: ACFacebookAudienceFriends
                                  };

        [accountRequest setOptions:options];
    }
}

#pragma mark Important for local Notifications
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[NSNotificationCenter defaultCenter] postNotificationName:ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings
                                                        object:self];
}
#endif

#pragma mark Boiler plate

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    GrantedPermissionsViewController *rootVC = [GrantedPermissionsViewController new];
    [rootVC.view setBackgroundColor:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000]];
    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
}

@end
