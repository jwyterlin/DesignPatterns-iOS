//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"

#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"

#import "HorizontalScroller.h"
#import "AlbumView.h"

@interface ViewController()<UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate> {
    
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    HorizontalScroller *scroller;
    
}

@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    currentAlbumIndex = 0;
    
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    // the uitableview that presents the album data
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    // Creating scroller
    scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self reloadScroller];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];

}

-(void)didReceiveMemoryWarning {
 
    [super didReceiveMemoryWarning];

}

-(void)showDataForAlbumAtIndex:(int)albumIndex {
    
    // defensive code: make sure the requested index is lower than the amount of albums
    if ( albumIndex < allAlbums.count ) {
        
        // fetch the album
        Album *album = allAlbums[albumIndex];
        // save the albums data to present it later in the tableview
        currentAlbumData = [album tr_tableRepresentation];
    
    } else {
        
        currentAlbumData = nil;
        
    }
    
    // we have the data we need, let's refresh our tableview
    [dataTable reloadData];
    
}

-(void)reloadScroller {
    
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    if (currentAlbumIndex < 0) currentAlbumIndex = 0;
    else if (currentAlbumIndex >= allAlbums.count) currentAlbumIndex = (int)allAlbums.count-1;
    
    [scroller reload];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
    
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return [currentAlbumData[@"titles"] count];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if ( ! cell )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return cell;

}

#pragma mark - HorizontalScrollerDelegate methods

-(void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index {
 
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
    
}

-(NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller*)scroller {
 
    return allAlbums.count;
    
}

-(UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index {
    
    Album *album = allAlbums[index];
    
    return [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
    
}

@end
