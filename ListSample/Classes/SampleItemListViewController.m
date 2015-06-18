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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonPressed:)];
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"cell";
}

- (void)configureCell:(CBEditListViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - Events

- (void)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
