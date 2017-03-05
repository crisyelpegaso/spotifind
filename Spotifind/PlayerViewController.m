//
//  PlayerViewController.m
//  Spotifind
//
//  Created by Maria cristina rodriguez on 11/11/16.
//  Copyright © 2016 Maria cristina rodriguez. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()<SPTAudioStreamingDelegate>
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [SPTAudioStreamingController sharedInstance];
    self.player.delegate = self;
    self.player.playbackDelegate = self;
    
   }

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self activateAudioSession];
    [self.player playSpotifyURI:self.currentSongUri startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            return;
        }
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    NSLog(@"is playing = %d", isPlaying);
    if (isPlaying) {
        [self activateAudioSession];
    }
}

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
   
}

- (void)activateAudioSession
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

@end
