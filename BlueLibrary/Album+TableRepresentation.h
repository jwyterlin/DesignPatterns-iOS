//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by Jhonathan Wyterlin on 9/1/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

-(NSDictionary*)tr_tableRepresentation;

@end
