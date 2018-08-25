//
//  CBEditListViewController.m
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "CBEditListViewController.h"
#import "CBEditListViewCell.h"

@interface CBEditListViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIAlertController *insertItemAlertController;

@end

@implementation CBEditListViewController
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemsSection = 0;
    self.deselectSelectedRow = YES;
}

#pragma mark - Properties

- (NSString *)addListItemAlertTitle {
    return NSLocalizedString(@"New Item", nil);
}

- (NSString *)addListItemAlertPlaceholder {
    return NSLocalizedString(@"Name", nil);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (!editing) {
        // try to find an empty item name field
        NSUInteger index = [self.tableView.visibleCells indexOfObjectPassingTest:^BOOL(CBEditListViewCell *cell, NSUInteger idx, BOOL *stop) {
            if (![cell isKindOfClass:[CBEditListViewCell class]])
                return NO;
            
            return [self isStringEmpty:cell.textField.text];
        }];
        
        // remove the 'empty' item for the row that was inserted
        if (index != NSNotFound) {
            CBEditListViewCell *cell = (CBEditListViewCell*) self.tableView.visibleCells[index];
            NSUInteger row = cell.textField.tag;
            
            [self willRemoveListItem:self.items[row]];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row + 1 inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [super setEditing:editing animated:animated];
}

#pragma mark - List Actions

- (void)willRemoveListItem:(id)item {
    // empty
}

- (void)didInsertListItemWithName:(NSString *)name {
    // empty
}

- (void)didChangeListItem:(id)item toName:(NSString *)name {
    // empty
}

#pragma mark - Misc

- (void)alertControllerSaveButtonPressed:(UIAlertController *)alertController {
    // insert the item
    UITextField *textField = alertController.textFields.firstObject;
    if ([self isStringEmpty:textField.text])
        return;
    
    [self insertItemWithName:textField.text animated:YES];
    
    self.insertItemAlertController = nil;
}

- (BOOL)isStringEmpty:(NSString *)text {
    if (!text.length) {
        return YES;
    }
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return !text.length;
}

#pragma mark - Table DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeItems.count + 1; // added 1 more for 'add item' row
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if (row == 0) {
        return self.addListItemViewCell;
    }
    
    // take off one to account for the 'add item' row
    // the index path must be adjusted for the orig data source, rather than the UI
    NSIndexPath *dataIndexPath = [NSIndexPath indexPathForRow:(row - 1) inSection:indexPath.section];
    CBEditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:dataIndexPath]];
    cell.textField.delegate = self;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    cell.textField.tag = dataIndexPath.row;
    
    [self configureCell:cell indexPath:dataIndexPath];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // The add row gets an insertion marker, the others a delete marker.
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }
    
    if (indexPath.section != self.itemsSection) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath)
        return;
    
    // only allow commits from the 'items' section
    if (indexPath.section != self.itemsSection) {
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CBEditListViewCell *cell = (CBEditListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField resignFirstResponder];
        
        [self willRemoveListItem:self.activeItems[indexPath.row - 1]];
        
        // remove the row
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self insertItemAnimated:YES];
    }
}

#pragma mark - Row selection

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Disable selection of the Add row while editing
    if (tableView.editing && indexPath.row == 0) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.deselectSelectedRow)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // if 'add item' was tapped
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.addListItemAlertTitle
                                                                                 message:NSLocalizedString(@"Enter a name.", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        __typeof__(self) __weak weakSelf = self;
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.insertItemAlertController = nil;
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf alertControllerSaveButtonPressed:weakSelf.insertItemAlertController];
        }]];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = self.addListItemAlertPlaceholder;
            textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textField.returnKeyType = UIReturnKeyDone;
        }];
        
        self.insertItemAlertController = alertController;
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self didSelectCellAtIndexPath:indexPath item:self.activeItems[indexPath.row - 1]];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag >= self.activeItems.count)
        return YES;
    
    id item = self.activeItems[textField.tag];
    [self didChangeListItem:item toName:textField.text];
    
    BOOL endEdit = ![self isStringEmpty:textField.text];
    return endEdit;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table Management

- (void)insertItemWithName:(NSString *)name animated:(BOOL)animated {
    [self didInsertListItemWithName:name];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.activeItems.count inSection:self.itemsSection];
    UITableViewRowAnimation animationStyle = UITableViewRowAnimationNone;
    if (animated)
        animationStyle = UITableViewRowAnimationFade;
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animationStyle];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)insertItemAnimated:(BOOL)animated {
    // prevent adding another item, when an empty field is available
    // try to find an empty item name field
    NSUInteger index = [self.tableView.visibleCells indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[CBEditListViewCell class]])
            return NO;
        
        CBEditListViewCell *cell = obj;
        return [self isStringEmpty:cell.textField.text];
    }];
    
    if (index != NSNotFound) {
        CBEditListViewCell *cell = (CBEditListViewCell*) self.tableView.visibleCells[index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.textField.tag inSection:self.itemsSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }
    
    [self insertItemWithName:@"" animated:animated];
    
    // Start editing the item's name
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.activeItems.count inSection:self.itemsSection];
    CBEditListViewCell *cell = (CBEditListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

@end
