//
//  HPYoutubeManager.h
//  HPYoutube
//
//  Created by Hervé PEROTEAU on 25/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

typedef void (^SuccessOperationBlock) (NSOperation *operation, id responseObject);
typedef void (^ErrorOperationBlock) (NSOperation *operation, NSError *error);

@interface HPHTTPClientYoutube : AFHTTPClient

-(id) initWithApiKey:(NSString *) apiKey;

-(NSOperation *) checkServerSuccess:(SuccessOperationBlock)success
                            failure:(ErrorOperationBlock)failure;

/**
    Quand success, l'objet responseObject est un tableau d'element de type HPYoutubeElement
 */
-(NSOperation *) searchVideos:(NSArray *) keywords
                    maxResult:(NSInteger) maxResult
                      success:(SuccessOperationBlock) success
                      failure:(ErrorOperationBlock) failure;

@end
