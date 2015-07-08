//
//  SampleItemListViewController.m
//  ListSample
//
//  Created by C. Bess on 6/16/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "SampleItemListViewController.h"
#import "SampleItem.h"
#import "CBEditListViewCell.h"

@implementation SampleItemListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Sample Items", nil);
    
    self.addListItemViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add"];
    self.addListItemViewCell.textLabel.text = @"Add Sample Item";
    
    // use built-in edit button
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    // disable the done button, if editing
    self.navigationItem.rightBarButtonItem.enabled = !editing;
}

#pragma mark - Misc

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"sampleitemcell";
}

- (void)configureCell:(CBEditListViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    SampleItem *item = self.activeItems[indexPath.row];
    cell.textField.text = [item displayTitle];
}

#pragma mark - List Actions

- (void)willRemoveListItem:(id)item {
    [self.items removeObject:item];
}

- (void)didInsertListItemWithName:(NSString *)name {
    SampleItem *item = [SampleItem itemWithName:name subtitle:@""];
    [self.items addObject:item];
}

- (void)didChangeListItem:(SampleItem *)item toName:(NSString *)name {
    item.name = name;
}

@end
