//
//  CBEditListViewController.h
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "CBListViewController.h"

@class CBEditListViewCell;

@interface CBEditListViewController : CBListViewController

@property (nonatomic, weak) id item;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableViewCell *addListItemViewCell;
@property (nonatomic, assign) BOOL deselectSelectedRow;

- (void)willRemoveItem:(id)item;
- (void)didInsertItemWithName:(NSString *)name;
- (void)didChangeItem:(id)item toName:(NSString *)name;

@end
