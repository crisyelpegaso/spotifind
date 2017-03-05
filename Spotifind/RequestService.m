//
//  RequestService.m
//  Spotifind
//
//  Created by Maria cristina rodriguez on 3/5/17.
//  Copyright © 2017 Maria cristina rodriguez. All rights reserved.
//

#import "RequestService.h"

@implementation RequestService

+(void)post:(NSURL *)url
           body:(NSString *)body
           completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError)) completionBlock {

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *rawBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:rawBody];
    [request setURL:url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        completionBlock(response, data, error);

    }];

}
@end
