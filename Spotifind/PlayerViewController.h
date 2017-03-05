//
//  PlayerViewController.h
//  Spotifind
//
//  Created by Maria cristina rodriguez on 11/11/16.
//  Copyright © 2016 Maria cristina rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <AVFoundation/AVAudioSession.h>

@interface PlayerViewController : UIViewController<SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>
@property NSString *currentSongUri;
@end
