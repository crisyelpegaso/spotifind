//
//  ViewController.m
//  Spotifind
//
//  Created by Maria cristina rodriguez on 10/19/16.
//  Copyright © 2016 Maria cristina rodriguez. All rights reserved.
//

#import "ViewController.h"
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <AVFoundation/AVAudioSession.h>
#import "PlayerViewController.h"

@interface ViewController () <SPTAudioStreamingDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (strong) NSString *currentSongUri;

@end

@implementation ViewController



- (IBAction)plauSongButton:(id)sender {
    
    PlayerViewController *playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    playerVC.currentSongUri = self.currentSongUri;
    [self.navigationController pushViewController:playerVC animated:true];
}

- (IBAction)searchSongsButton:(id)sender {
    

    NSURL *url = [[NSURL alloc] initWithString:@"https://private-81bfd9-pmsnative.apiary-mock.com/songsNearBy"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    [request setURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error == nil) {
                NSMutableDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dataAsString %@", [NSString stringWithUTF8String:[data bytes]]);
                self.currentSongUri = [responseJson objectForKey:@"uri"];
//                NSObject *response = [NSJSONSerialization [JSONObjectWithData:data options:JSONSerialization.ReadingOptions.allowFragments error:nil)] ];
                NSLog(@"song found %@", self.currentSongUri);
                _songLabel.text = self.currentSongUri;
            } else {
                NSLog(@"** request failed, error : @% **", error);
            }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming {
    
//    [self.player playSpotifyURI:@"spotify:user:spotify:playlist:2yLXxKhhziG2xzy7eyD4TD" startingWithIndex:0 startingWithPosition:10 callback:^(NSError *error) {
//        if (error != nil) {
//            NSLog(@"*** failed to play: %@", error);
//            return;
//        }
//    }];
}

@end
