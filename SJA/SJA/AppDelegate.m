#import "AppDelegate.h"
#import "Appirater.h"
#import "RotatableNavController.h"
#import <Parse/Parse.h>
#import "KalViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) RotatableNavController *navigationController;

@end


@implementation AppDelegate

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Appirater appEnteredForeground:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Appirater config
    [Appirater setAppId:@"534847135"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // Parse config for push notifications + analytics
    [Parse setApplicationId:[config objectForKey:@"Parse_App_Key"]
                  clientKey:[config objectForKey:@"Parse_Client_Key"]];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    [self configureNavigationBarHeader];
    self.navigationController = (RotatableNavController *)self.window.rootViewController;
    self.navigationController.navigationBar.barTintColor = [UIColor SJAGreen];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)configureNavigationBarHeader {
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"CopperplateGothicStd-31BC" size:28]}];
}


@end
