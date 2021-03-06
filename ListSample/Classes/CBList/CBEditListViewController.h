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

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableViewCell *addListItemViewCell;
@property (nonatomic, assign) BOOL deselectSelectedRow;
/// The table section for items. Defaults to 0.
@property (nonatomic, readonly) NSInteger itemsSection;
@property (nonatomic, copy, readonly) NSString *addListItemAlertTitle;
@property (nonatomic, copy, readonly) NSString *addListItemAlertPlaceholder;

/// The item is about to be removed from the list.
/// The data source should remove the item. But, you can use it before it is removed.
- (void)willRemoveListItem:(id)item;

/// An item was inserted into the list with the specified name.
/// The data source should insert a new item with the specified name.
- (void)didInsertListItemWithName:(NSString *)name;

/// An item's name was changed to the specified name.
/// The data source should update the name for the data source.
- (void)didChangeListItem:(id)item toName:(NSString *)name;

@end
