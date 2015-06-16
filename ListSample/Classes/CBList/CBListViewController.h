//
//  CBListViewController.h
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBListViewControllerListItem.h"

typedef UITableViewCell *(^CBListViewControllerConfigureCellBlock)(NSIndexPath *indexPath, id cell);
typedef void(^CBListViewControllerConfigureCellSelectedBlock)(NSIndexPath *indexPath, id item);

/**
 Represents a list view controller.
 The UITableViewDataSource methods should be overriden to avoid overhead if using custom cells.
 */
@interface CBListViewController : UITableViewController

/// The items displayed in the list.
@property (nonatomic, strong) NSArray *items;

/// The search results displayed in the search list.
@property (nonatomic, strong) NSArray *searchResults;

/**
 Configures the table view. By default it registers the default cell class.
 Avoid calling super to ignore default configuration.
 */
- (void)configureTableView;

/// Reloads the table data.
- (void)reloadData;

/// The cell identifier for the cell at the specified index path
- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

/**
 Configure the cell for the specified index path. It can be altered or a new one returned, or nil to use the default.
 */
- (void)configureCellBlock:(CBListViewControllerConfigureCellBlock)block;

/// Configures the cell selected block.
- (void)configureCellSelectedBlock:(CBListViewControllerConfigureCellSelectedBlock)block;

@end

