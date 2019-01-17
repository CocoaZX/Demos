//
//  AppDelegate.h
//  Mocha
//
//  Created by renningning on 14-11-19.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"
#import "CustomTabBarController.h"
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>
#import "GexinSdk.h"
#import "McMainController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "EaseMobHeaders.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CustomTabBarControllerDelegate,WXApiDelegate,GexinSdkDelegate,CLLocationManagerDelegate,TencentSessionDelegate,IChatManagerDelegate>{
    CustomTabBarController* _customTabBarController;
    enum WXScene _scene;
    NSString *_deviceToken;
    EMConnectionState _connectionState;


}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Reachability *hostReach;

@property (strong, nonatomic) UINavigationController *mainNavController;

@property (strong, nonatomic) CLLocationManager *locManager;
@property (assign, nonatomic) CLLocationDegrees lat;
@property (assign, nonatomic) CLLocationDegrees lng;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//个推
@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)showMainViewController;

- (void)showBangDingViewController;

- (void)showAccountViewController;

- (void)showAccountViewControllerWithCon:(UIViewController *)controller;

BOOL isLogin();
NSString *currentUID();

@end

