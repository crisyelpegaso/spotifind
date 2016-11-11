//
//  AppDelegate.m
//  Spotifind
//
//  Created by Maria cristina rodriguez on 10/19/16.
//  Copyright © 2016 Maria cristina rodriguez. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@property (nonatomic, strong) SPTAuth *auth;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) UIViewController *authViewController;



@end

@implementation AppDelegate

NSString *const kCallbackUri = @"spotifind://find";
NSString *const kClientId = @"0d80ca2af1eb4f2680594eb5b8474ce3";
NSString *const kTrackUri = @"spotify:track:6ooluO7DiEhI1zmK94nRCM";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.auth = [SPTAuth defaultInstance];
    self.player = [SPTAudioStreamingController sharedInstance];
    self.auth.clientID = kClientId;
    self.auth.redirectURL = [NSURL URLWithString:kCallbackUri];
    self.auth.sessionUserDefaultsKey = @"SpotifySession";
    self.auth.requestedScopes = @[SPTAuthStreamingScope];
    
    self.player.delegate = self;
    
    // Start up the streaming controller.
    NSError *audioStreamingInitError;
    NSAssert([self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError],
             @"There was a problem starting the Spotify SDK: %@", audioStreamingInitError.description);
    
    // Start authenticating when the app is finished launching
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAuthenticationFlow];
    });
    
    return YES;
}

- (void)startAuthenticationFlow {
    // Check if we could use the access token we already have
    if ([self.auth.session isValid]) {
        // Use it to log in
        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
        [self.player loginWithAccessToken:self.auth.session.accessToken];
    } else {
        // Get the URL to the Spotify authorization portal
        NSURL *authURL = [self.auth spotifyWebAuthenticationURL];
        // Present in a SafariViewController
        self.authViewController = [[SFSafariViewController alloc] initWithURL:authURL];
        [self.window.rootViewController presentViewController:self.authViewController animated:YES completion:nil];
    }
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    
    // If the incoming url is what we expect we handle it
    if ([self.auth canHandleURL:url]) {
        // Close the authentication window
        [self.authViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        self.authViewController = nil;
        // Parse the incoming url to a session object
        [self.auth handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (session) {
                // login to the player
                [self.player loginWithAccessToken:self.auth.session.accessToken];
            }
        }];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        if (error != nil) {
            NSLog(@"*** Auth error: %@", error);
            return;
        }
        
        auth.session = session;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sessionUpdated" object:self];
    };
    
    if ([auth canHandleURL:url]) {
        [auth handleAuthCallbackWithTriggeredAuthURL:url callback:authCallback];
        return YES;
    }
    
    return NO;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error != nil) {
                NSLog(@"*** Auth error: %@", error);
                return;
            }

            [self loginUsingSession:session];
        }];
        return YES;
    }
    
    return NO;
}

-(void)loginUsingSession:(SPTSession *)session {
    // Get the player instance
    self.player = [SPTAudioStreamingController sharedInstance];
    self.player.delegate = self;
    // Start the player (will start a thread)
    [self.player startWithClientId:kClientId error:nil];
    // Login SDK before we can start playback
    [self.player loginWithAccessToken:session.accessToken];
}

//- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
//    [self activateAudioSession];
//    [self.player playSpotifyURI:kTrackUri startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
//        if (error != nil) {
//            NSLog(@"*** failed to play: %@", error);
//            return;
//        }
//    }];
//
//}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(NSError *)error {
    NSLog(@"*** =( : %@", error);
}

- (void)activateAudioSession
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
