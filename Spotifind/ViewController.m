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
#import <CoreLocation/CoreLocation.h>
#import "LocationUtils.h"
#import "RequestService.h"

@interface ViewController () <SPTAudioStreamingDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (strong) NSString *trackFoundId;
@property (nonatomic) double latitude, longitude;

@end

@implementation ViewController

NSString *kURL = @"https://spotifindservice.herokuapp.com";
NSString *kFindTrackURI =  @"/find_track";
NSString *kSaveTrackURL = @"/save_track";
NSString *kTrackUrl = @"spotify:track:";


- (IBAction)playSongButton:(id)sender {
    
    PlayerViewController *playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    playerVC.currentSongUri = [NSString stringWithFormat:@"%@%@", kTrackUrl, self.trackFoundId];
    [self.navigationController pushViewController:playerVC animated:true];
}

- (IBAction)searchSongsButton:(id)sender {
    
    [self loadCurrentLocation];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", kURL, kFindTrackURI];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSString *latString = [NSString stringWithFormat:@"%.20lf", self.latitude];
    NSString *longString = [NSString stringWithFormat:@"%.20lf", self.longitude];

    NSString *stringBody = [NSString stringWithFormat:@"{ \"lat\" : \"%@\" , \"long\" :\"%@\" }", latString, longString];
    
    [RequestService post:url body:stringBody completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSMutableDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dataAsString %@", [NSString stringWithUTF8String:[data bytes]]);
            self.trackFoundId = [responseJson objectForKey:@"track_id"];
            NSLog(@"song found %@", self.trackFoundId);
            _songLabel.text = [responseJson objectForKey:@"name"];
        } else {
            NSLog(@"** request failed, error : @% **", connectionError);
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self sendCurrentLocation];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCurrentLocation
{
    CLLocationCoordinate2D coordinate = [LocationUtils getCurrentLocation];
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.latitude;
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",self.latitude,self.longitude];
    NSLog(@"%@",str);
    
}

-(void) sendCurrentLocation {
    CLLocationCoordinate2D coordinate = [LocationUtils getCurrentLocation];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kURL, kSaveTrackURL];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSString *latString = [NSString stringWithFormat:@"%.20lf", self.latitude];
    NSString *longString = [NSString stringWithFormat:@"%.20lf", self.longitude];
    
    //TODO : hardcoded track
    NSString *stringBody = [NSString stringWithFormat:@"{ \"track_id\" : \"%@\" , \"lat\" : \"%@\" , \"long\" :\"%@\" }", @"4SmXshkCVypEw4dco0cYc4", latString, longString];
    
    [RequestService post:url body:stringBody completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSMutableDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dataAsString %@", [NSString stringWithUTF8String:[data bytes]]);
            
        } else {
            NSLog(@"** request failed, error : @% **", connectionError);
        }
    }];
    
}



@end
