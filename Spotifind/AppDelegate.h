//
//  AppDelegate.h
//  Spotifind
//
//  Created by Maria cristina rodriguez on 10/19/16.
//  Copyright © 2016 Maria cristina rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <SafariServices/SafariServices.h>
#import <AVFoundation/AVAudioSession.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>


@property (strong, nonatomic) UIWindow *window;


@end

