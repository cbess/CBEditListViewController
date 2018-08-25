//
//  CBListViewController.m
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "CBListViewController.h"

static NSString * const kCellIdentifier = @"cell";

@interface CBListViewController ()
@property (nonatomic, assign) BOOL searchActive;
@property (nonatomic, copy) CBListViewControllerConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) CBListViewControllerConfigureCellSelectedBlock configureCellSelectedBlock;
@end

@implementation CBListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureForPopover];
    [self configureTableView];
}

#pragma mark - Properties

- (NSArray *)activeItems {
    return (self.searchActive ? self.searchResults : self.items);
}

- (UIModalPresentationStyle)popoverPresentationStyle {
    // return None to present as a popover on both iPhone and iPad
    return UIModalPresentationNone;
}

#pragma mark - UIPopover

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return self.popoverPresentationStyle;
}

#pragma mark - Misc

- (void)configureCellBlock:(CBListViewControllerConfigureCellBlock)configureCellBlock {
    self.configureCellBlock = configureCellBlock;
}

- (void)configureCellSelectedBlock:(CBListViewControllerConfigureCellSelectedBlock)block {
    self.configureCellSelectedBlock = block;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)configureTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)configureForPopover {
    self.preferredContentSize = CGSizeMake(250, 350);
    // pres style must be set before accessing popoverPresentationController property
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.popoverPresentationController.delegate = self;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return kCellIdentifier;
}

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (self.configureCellBlock) {
        id aCell = self.configureCellBlock(indexPath, cell);
        
        // if a cell is provided, then use it
        if (aCell) {
            cell = aCell;
        }
    }
}

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath item:(id)item {
    if (self.configureCellSelectedBlock) {
        self.configureCellSelectedBlock(indexPath, item);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
    id item = self.activeItems[indexPath.row];
    
    // use the item info if it is available
    if ([item conformsToProtocol:@protocol(CBListViewControllerListItem)]) {
        id<CBListViewControllerListItem> listItem = item;
        
        cell.textLabel.text = [listItem displayTitle];
        cell.detailTextLabel.text = [listItem displayDetailTitle];
    }
    
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectCellAtIndexPath:indexPath item:self.activeItems[indexPath.row]];
}

@end
