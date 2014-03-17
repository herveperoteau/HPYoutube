//
//  HPYoutubeManager.h
//  HPYoutube
//
//  Created by Hervé PEROTEAU on 25/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^SuccessTaskBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^ErrorTaskBlock)(NSURLSessionDataTask *task, NSError *error);

@interface HPHTTPClientYoutube : AFHTTPSessionManager

-(id) initWithApiKey:(NSString *) apiKey;

-(NSURLSessionDataTask *) checkServerSuccess:(SuccessTaskBlock)success
                                     failure:(ErrorTaskBlock)failure;

/**
    Quand success, l'objet responseObject est un tableau d'element de type HPYoutubeElement
 */
-(NSURLSessionDataTask *) searchVideos:(NSArray *) keywords
                             maxResult:(NSInteger) maxResult
                               success:(SuccessTaskBlock) success
                               failure:(ErrorTaskBlock) failure;

@end
