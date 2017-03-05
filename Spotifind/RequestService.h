//
//  RequestService.h
//  Spotifind
//
//  Created by Maria cristina rodriguez on 3/5/17.
//  Copyright © 2017 Maria cristina rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestService : NSObject

+(void)post:(NSURL *)url
        body:(NSString *)body
        completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError)) completionBlock;


@end
