//
//  HPYoutubeManager.m
//  HPYoutube
//
//  Created by Hervé PEROTEAU on 25/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//
// Acces aux api de Youtube
// GET https://www.googleapis.com/youtube/v3/search?part=snippet&q=daftpunk%2Cinstant%2Ccrush&key={YOUR_API_KEY}
//

#import "HPHTTPClientYoutube.h"
#import "HPYoutubeElement.h"
#import <AFNetworking.h>

static NSString * const kYoutubeAPIBaseURLString = @"https://www.googleapis.com/youtube/v3";

@implementation HPHTTPClientYoutube {
    
    NSString *_apiKey;
}

-(id) initWithApiKey:(NSString *) apiKey {
    
    if ((self = [self initWithBaseURL:[NSURL URLWithString:kYoutubeAPIBaseURLString]])) {
        
        _apiKey = apiKey;
    }
    
    return self;
}

-(NSURLSessionDataTask *) checkServerSuccess:(SuccessTaskBlock)success
                                     failure:(ErrorTaskBlock)failure {

    NSAssert(_apiKey, @"keyApi is nil !!!");
    
    NSURLSessionDataTask *task = [self GET:@"search"
                                parameters:@{@"part":@"id", @"key" : _apiKey}
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       if (success)
                                           success(task, @"ok");
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {

                                       if (failure)
                                           failure(task, error);
                                   }];

    return task;
}

-(NSURLSessionDataTask *) searchVideos:(NSArray *) keywords
                             maxResult:(NSInteger) maxResult
                               success:(SuccessTaskBlock) success
                               failure:(ErrorTaskBlock) failure {
    
    NSAssert(_apiKey, @"keyApi is nil !!!");
    
    NSURLSessionDataTask *task = [self GET:@"search"
                                parameters:@{@"part":@"snippet",
                                             @"type": @"video",
                                             @"q":[keywords componentsJoinedByString:@"+"],
                                             @"maxResults": [NSString stringWithFormat:@"%d", maxResult],
                                             @"key" : _apiKey}
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       NSDictionary *json = (NSDictionary *) responseObject;
                                       
                                       NSArray *items = [json objectForKey:@"items"];
                                       
                                       NSArray *result = [self parseJSONToHPYoutubeElement:items];

                                       if (success)
                                           success(task, result);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       
                                       if (failure)
                                           failure(task, error);
                                   }];
    
    return task;
}

//-(NSOperation *) searchVideos:(NSArray *) keywords
//                    maxResult:(NSInteger) maxResult
//                      success:(SuccessOperationBlock) success
//                      failure:(ErrorOperationBlock) failure {
//
//    NSAssert(keyApi, @"keyApi is nil !!!");
//    NSAssert(maxResult>0 && maxResult<=50, @"maxResult must be > 0 and <= 50");
//    
//    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
//                                                      path:@"search"
//                                                parameters:@{@"part":@"snippet",
//                                                             @"type": @"video",
//                                                             @"q":[keywords componentsJoinedByString:@"+"],
//                                                             @"maxResults": [NSString stringWithFormat:@"%d", maxResult],
//                                                             @"key" : keyApi}];
//    
//    
//    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        // transforme Dictionnary JSON en un tableau de HPYoutubeElement(s)
//        NSDictionary *json = (NSDictionary *) responseObject;
//        
//        NSArray *items = [json objectForKey:@"items"];
//        
//        NSArray *result = [self parseJSONToHPYoutubeElement:items];
//        
//        if (success) {
//            success (operation, result);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (failure) {
//            failure (operation, error);
//        }
//    }];
//    
//    [operation start];
//    
//    return operation;
//}

/**
 {
    "kind": "youtube#searchListResponse",
    "etag": "\"miHKzyWv_wJLndiE-Z-aewP7z0g/WolJU8qwzAsW23cTIKUTJMxcOKk\"",
    "pageInfo": {
        "totalResults": 1000000,
        "resultsPerPage": 5
    },
    "nextPageToken": "CAUQAA",
 
    "items": 
    [
        .../.../...
    ]
 }
 */
-(NSArray *) parseJSONToHPYoutubeElement:(NSArray *) items {

    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *item in items) {
        
        HPYoutubeElement *element = [[HPYoutubeElement alloc] initWithJSON:item];
        [result addObject:element];
    }
    
    return [NSArray arrayWithArray:result];
}


@end

















