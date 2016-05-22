//
//  CBListViewController.h
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBListViewControllerListItem.h"

typedef UITableViewCell  * _Nullable (^CBListViewControllerConfigureCellBlock)(NSIndexPath * _Nonnull indexPath, id _Nonnull cell);
typedef void(^CBListViewControllerConfigureCellSelectedBlock)(NSIndexPath * _Nonnull indexPath, id _Nonnull item);

/**
 Represents a list view controller.
 The UITableViewDataSource methods should be overriden to avoid overhead if using custom cells.
 */
@interface CBListViewController : UITableViewController

/// The items displayed in the list.
@property (nonatomic, strong, nullable) NSArray *items;

/// The search results displayed in the search list.
@property (nonatomic, strong, nullable) NSArray *searchResults;

/// Normal items or search results, depending on if search is active.
@property (nonatomic, readonly, nullable) NSArray *activeItems;

/**
 Configures the table view. By default it registers the default cell class.
 Avoid calling super to ignore default configuration.
 */
- (void)configureTableView;

/// Reloads the table data.
- (void)reloadData;

/// The cell identifier for the cell at the specified index path. Defaults to 'cell'.
- (NSString * _Nonnull)cellIdentifierAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

/**
 Configure the cell for the specified index path. It can be altered or a new one returned, or nil to use the default.
 */
- (void)configureCellBlock:(nullable CBListViewControllerConfigureCellBlock)block;

/// Configures the cell selected block.
- (void)configureCellSelectedBlock:(nullable CBListViewControllerConfigureCellSelectedBlock)block;

/// Handles the configuration of the specified table view cell at the specified index path
- (void)configureCell:(UITableViewCell * _Nonnull)cell indexPath:(NSIndexPath * _Nonnull)indexPath;

/// The cell at the specified index path was selected.
- (void)didSelectCellAtIndexPath:(NSIndexPath * _Nonnull)indexPath item:(id _Nonnull)item;

@end

