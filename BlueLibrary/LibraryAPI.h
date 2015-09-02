//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Jhonathan Wyterlin on 9/1/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Album.h"

@interface LibraryAPI : NSObject

+(LibraryAPI *)sharedInstance;

-(NSArray *)getAlbums;
-(void)addAlbum:(Album*)album atIndex:(int)index;
-(void)deleteAlbumAtIndex:(int)index;
-(void)saveAlbums;

@end
