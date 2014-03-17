//
//  HPYoutubeTests.m
//  HPYoutubeTests
//
//  Created by Hervé PEROTEAU on 25/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HPHTTPClientYoutube.h"
#import "HPYoutubeElement.h"

#define API_KEY_DEF @"AIzaSyCq18P86Q2ZhnSruV50uWz6si8YBbbpyXY"   // herve.peroteau@gmail.com


@interface HPYoutubeTests : XCTestCase

@end

@implementation HPYoutubeTests {
    
    HPHTTPClientYoutube *youtubeManager;
    
    dispatch_semaphore_t semaphore;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    youtubeManager = [[HPHTTPClientYoutube alloc] initWithApiKey:API_KEY_DEF];

    semaphore = dispatch_semaphore_create(0);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testConnect {
    
    __block BOOL serverOk = NO;
    
    [youtubeManager checkServerSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Success:%@ !!!", responseObject);

        serverOk = YES;
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error:%@ !!!", error);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    XCTAssertTrue(serverOk, @"Server not available");
}

-(void) testSearch {
    
    [youtubeManager searchVideos:@[@"daft punk", @"get lucky"]
                       maxResult:10
                         success:^(NSURLSessionDataTask *task, id responseObject) {

                             NSLog(@"Success: (%@) %@", [responseObject class], responseObject);
                             dispatch_semaphore_signal(semaphore);

                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                             
                             NSLog(@"Error: %@", error);
                             dispatch_semaphore_signal(semaphore);
                         }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];

}

//-(void) testSearchDaftPunkGetLucky {
//
//    NSArray *keywords = @[@"daftpunk", @"get lucky"];
//    
//    __block BOOL searchOk = NO;
//    
//    [youtubeManager searchVideos:keywords
//                       maxResult:10
//                         success:^(NSOperation *operation, id responseObject) {
//                             
//                             NSArray *results = (NSArray *)responseObject;
//                             
//                             [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                 
//                                 NSLog(@"Result n°%d:\n%@\n-------------\n", (idx+1), obj);
//                             
//                                 HPYoutubeElement *element = (HPYoutubeElement *) obj;
//                                 
//                                 if ( [element.title rangeOfString:@"Daft" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
//                                     
//                                     if ( [element.title rangeOfString:@"Lucky" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
//                                         
//                                         searchOk = YES;
//                                     }
//                                 }
//                             }];
//                             
//                             dispatch_semaphore_signal(semaphore);
//                             
//    } failure:^(NSOperation *operation, NSError *error) {
//        
//        NSLog(@"Error:%@ !!!", error);
//        dispatch_semaphore_signal(semaphore);
//    }];
//    
//    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//    
//    XCTAssertTrue(searchOk, @"Search Daft+Lucky error");
//}
//
//-(void) testSearchDaftPunkInstantCrush {
//    
//    NSArray *keywords = @[@"daftpunk", @"Instant Crush"];
//    
//    __block BOOL searchOk = NO;
//    
//    [youtubeManager searchVideos:keywords
//                       maxResult:10
//                         success:^(NSOperation *operation, id responseObject) {
//                             
//                             NSArray *results = (NSArray *)responseObject;
//                             
//                             [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                 
//                                 NSLog(@"Result n°%d:\n%@\n-------------\n", (idx+1), obj);
//                                 
//                                 HPYoutubeElement *element = (HPYoutubeElement *) obj;
//                                 
//                                 if ( [element.title rangeOfString:@"Daft" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
//                                     
//                                     if ( [element.title rangeOfString:@"Instant" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
//                                         
//                                         searchOk = YES;
//                                     }
//                                 }
//                             }];
//                             
//                             dispatch_semaphore_signal(semaphore);
//                             
//                         } failure:^(NSOperation *operation, NSError *error) {
//                             
//                             NSLog(@"Error:%@ !!!", error);
//                             dispatch_semaphore_signal(semaphore);
//                         }];
//    
//    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//    
//    XCTAssertTrue(searchOk, @"Search Daft+Instant error");
//}
//
//-(void) testSearchSaezRochechouart {
//    
//    NSArray *keywords = @[@"Saez", @"Rochechouart"];
//    
//    __block BOOL searchOk = NO;
//    
//    [youtubeManager searchVideos:keywords
//                       maxResult:10
//                         success:^(NSOperation *operation, id responseObject) {
//                             
//                             NSArray *results = (NSArray *)responseObject;
//                             
//                             [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                 
//                                 NSLog(@"Result n°%d:\n%@\n-------------\n", (idx+1), obj);
//                                 
//                                 HPYoutubeElement *element = (HPYoutubeElement *) obj;
//                                 
//                                 if ( [element.title rangeOfString:@"Saez" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
//                                     
//                                     if ( [element.title rangeOfString:@"Rochechouart" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
//                                         
//                                         searchOk = YES;
//                                     }
//                                 }
//                             }];
//                             
//                             dispatch_semaphore_signal(semaphore);
//                             
//                         } failure:^(NSOperation *operation, NSError *error) {
//                             
//                             NSLog(@"Error:%@ !!!", error);
//                             dispatch_semaphore_signal(semaphore);
//                         }];
//    
//    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//    
//    XCTAssertTrue(searchOk, @"Search Saez+Rochechouart error");
//}
//


@end











