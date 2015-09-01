//
//  Album+TableRepresentation.m
//  BlueLibrary
//
//  Created by Jhonathan Wyterlin on 9/1/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

-(NSDictionary*)tr_tableRepresentation {
    
    return @{ @"titles":@[@"Artist", @"Album", @"Genre", @"Year"],
              @"values":@[self.artist, self.title, self.genre, self.year] };
}

@end
