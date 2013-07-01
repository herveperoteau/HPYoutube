//
//  HPYoutubeElement.h
//  HPYoutube
//
//  Created by Hervé PEROTEAU on 29/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPYoutubeElement : NSObject

@property (nonatomic, readonly) NSString *videoId;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) NSString *thumbnail_default;
@property (nonatomic, readonly) NSString *thumbnail_high;
@property (nonatomic, readonly) NSString *publishedAt;
@property (nonatomic, readonly) NSString *urlVideo;

-(id) initWithJSON:(NSDictionary *)JSON;

@end
