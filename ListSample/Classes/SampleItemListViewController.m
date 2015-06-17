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
    
    self.addListItemViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add"];
    self.addListItemViewCell.textLabel.text = @"Add Sample Item";
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"cell";
}

- (void)configureCell:(CBEditListViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SampleItem *item = self.activeItems[indexPath.row];
    cell.textField.text = [item displayTitle];
}

@end
