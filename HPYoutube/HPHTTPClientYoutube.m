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
#import "AFJSONRequestOperation.h"

static NSString * const kYoutubeAPIBaseURLString = @"https://www.googleapis.com/youtube/v3";

@implementation HPHTTPClientYoutube {
    
    NSString *keyApi;
}

-(id) initWithApiKey:(NSString *) apiKey {
    
    if ((self = [self initWithBaseURL:[NSURL URLWithString:kYoutubeAPIBaseURLString]])) {
        
        keyApi = apiKey;
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	//[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

-(NSOperation *) checkServerSuccess:(SuccessOperationBlock) success
                            failure:(ErrorOperationBlock) failure {

    NSAssert(keyApi, @"keyApi is nil !!!");

    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                         path:@"search"
                                                   parameters:@{@"part":@"id", @"key" : keyApi}];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success (operation, @"ok");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure (operation, error);
        }
    }];
    
    [operation start];

    return operation;
}

-(NSOperation *) searchVideos:(NSArray *) keywords
                    maxResult:(NSInteger) maxResult
                      success:(SuccessOperationBlock) success
                      failure:(ErrorOperationBlock) failure {

    NSAssert(keyApi, @"keyApi is nil !!!");
    NSAssert(maxResult>0 && maxResult<=50, @"maxResult must be > 0 and <= 50");
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:@"search"
                                                parameters:@{@"part":@"snippet",
                                                             @"type": @"video",
                                                             @"q":[keywords componentsJoinedByString:@"+"],
                                                             @"maxResults": [NSString stringWithFormat:@"%d", maxResult],
                                                             @"key" : keyApi}];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // transforme Dictionnary JSON en un tableau de HPYoutubeElement(s)
        NSDictionary *json = (NSDictionary *) responseObject;
        
        NSArray *items = [json objectForKey:@"items"];
        
        NSArray *result = [self parseJSONToHPYoutubeElement:items];
        
        if (success) {
            success (operation, result);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure (operation, error);
        }
    }];
    
    [operation start];
    
    return operation;
}

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

















