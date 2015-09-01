//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Jhonathan Wyterlin on 9/1/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "LibraryAPI.h"

#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI () {
    
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    BOOL isOnline;
    
}

@end

@implementation LibraryAPI

+(LibraryAPI*)sharedInstance {
 
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    
    return _sharedInstance;
    
}

-(id)init {
 
    self = [super init];
    
    if (self) {
    
        persistencyManager = [[PersistencyManager alloc] init];
        httpClient = [[HTTPClient alloc] init];
        isOnline = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
        
    }
    
    return self;
    
}

-(NSArray*)getAlbums {
    
    return [persistencyManager getAlbums];
    
}

-(void)addAlbum:(Album*)album atIndex:(int)index {
    
    [persistencyManager addAlbum:album atIndex:index];

    if ( isOnline )
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];

}

-(void)deleteAlbumAtIndex:(int)index {
  
    [persistencyManager deleteAlbumAtIndex:index];
    
    if ( isOnline )
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];

}

- (void)downloadImage:(NSNotification*)notification
{
    // 1
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    
    // 2
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    if (imageView.image == nil)
    {
        // 3
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            // 4
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }    
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
