//
//  HPYoutubeElement.m
//  HPYoutube
//
//  Created by Hervé PEROTEAU on 29/06/13.
//  Copyright (c) 2013 Hervé PEROTEAU. All rights reserved.
//

#import "HPYoutubeElement.h"

#define PREFIXE_URL_VIDEO @"http://www.youtube.com/watch?v="

@interface HPYoutubeElement ()

@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *publishedAt;
@property (nonatomic, strong) NSString *thumbnail_default;
@property (nonatomic, strong) NSString *thumbnail_high;
@property (nonatomic, strong) NSString *urlVideo;

@end

@implementation HPYoutubeElement

-(id) initWithJSON:(NSDictionary *)JSON {

    if ((self = [super init])) {

        [self parseJSONDictionnary:JSON];
    }
    
    return self;
}


/**
 {
    "kind": "youtube#searchResult",
    "etag": "\"miHKzyWv_wJLndiE-Z-aewP7z0g/68WHsTRrxbFpnb00NymdsZvq0hM\"",
    "id":
    {
        "kind": "youtube#video",
        "videoId": "5NV6Rdv1a3I"
    },
    "snippet":
    {
        "publishedAt": "2013-04-19T06:55:07.000Z",
        "channelId": "UCKHFvArwRwQU2VbRjMpaVGw",
        "title": "Daft Punk - Get Lucky (Official Audio) ft. Pharrell Williams",
        "description": "Available now on iTunes: http://smarturl.it/GetLucky Pre-Order Random Access Memories, in-stores 5/21/13: iTunes: http://smarturl.it/RAMiTunes Amazon ...",
        "thumbnails":
        {
            "default":
            {
                "url": "https://i.ytimg.com/vi/5NV6Rdv1a3I/default.jpg"
            },
            "medium":
            {
                "url": "https://i.ytimg.com/vi/5NV6Rdv1a3I/mqdefault.jpg"
            },
            "high":
            {
                "url": "https://i.ytimg.com/vi/5NV6Rdv1a3I/hqdefault.jpg"
            }
        },
        "channelTitle": "DaftPunkVEVO"
    }
 }
 */
-(void) parseJSONDictionnary:(NSDictionary *) json {
    
    NSDictionary *idDico = [json objectForKey:@"id"];
    
    if (!idDico) {
        return;
    }
    
    self.videoId = [idDico objectForKey:@"videoId"];
    
    NSDictionary *snippet = [json objectForKey:@"snippet"];

    self.title = [snippet objectForKey:@"title"];
    self.desc = [snippet objectForKey:@"description"];
    self.publishedAt = [snippet objectForKey:@"publishedAt"];
    
    NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];

    NSDictionary *thumbnailDefaultDico = [thumbnails objectForKey:@"default"];
    self.thumbnail_default = [thumbnailDefaultDico objectForKey:@"url"];
    
    NSDictionary *thumbnailHighDico = [thumbnails objectForKey:@"high"];
    self.thumbnail_high = [thumbnailHighDico objectForKey:@"url"];
    
    self.urlVideo = [NSString stringWithFormat:@"%@%@", PREFIXE_URL_VIDEO, self.videoId];
}

-(NSString *) description {
    
    return [NSString stringWithFormat:@"HPYoutubeElement videoId:%@\ntitle:%@\ndesc:%@\npublishedAt:%@\nthumbnail_default:%@\nthumbnail_high:%@\nurlVideo:%@",
                self.videoId,
                self.title,
                self.desc,
                self.publishedAt,
                self.thumbnail_default,
                self.thumbnail_high,
                self.urlVideo];
}

@end
