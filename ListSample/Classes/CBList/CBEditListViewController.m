//
//  CBEditListViewController.m
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "CBEditListViewController.h"
#import "CBEditListViewCell.h"

#define kAlertViewTextFieldTag 99

@interface CBEditListViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIAlertView *insertItemAlertView;

@end

@implementation CBEditListViewController
@synthesize items;

#pragma mark - Properties

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (!editing)
    {
        // try to find an empty item name field
        NSUInteger index = [self.tableView.visibleCells indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[CBEditListViewCell class]])
                return NO;
            
            CBEditListViewCell *cell = obj;
            return [self isStringEmpty:cell.textField.text];
        }];
        
        if (index != NSNotFound)
        {
            CBEditListViewCell *cell = (CBEditListViewCell*) self.tableView.visibleCells[index];
            NSUInteger row = cell.textField.tag;
            
            // cancel, edit, and focus field
            [self willRemoveItem:self.items[row]];
            [self.items removeObjectAtIndex:row];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row + 1 inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [super setEditing:editing animated:animated];
}

#pragma mark - Misc

- (void)willRemoveItem:(id)item {
    // empty
}

- (void)didInsertItemWithName:(NSString *)name {
    // empty
}

- (void)didChangeItem:(id)item toName:(NSString *)name {
    // empty
}

- (BOOL)isStringEmpty:(NSString *)text {
    if (!text.length) {
        return YES;
    }
    
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return !text.length;
}

#pragma mark - Table DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activeItems.count + 1; // added 1 more for 'add item' row
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if (row == 0) {
        return self.addListItemViewCell;
    }
    
    --row; // take off one to account for the 'add item' row
    indexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
    CBEditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:indexPath]
                                                               forIndexPath:indexPath];
    cell.textField.delegate = self;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    cell.textField.tag = row;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The add row gets an insertion marker, the others a delete marker.
    if (indexPath.row == 0)
    {
        return UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath)
        return;
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CBEditListViewCell *cell = (CBEditListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField resignFirstResponder];
        
        [self willRemoveItem:self.activeItems[indexPath.row - 1]];
        
        // remove the row
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self insertItemAnimated:YES];
    }
}

#pragma mark - Row selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable selection of the Add row while editing
    if (tableView.editing && indexPath.row == 0)
    {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // 'add item' was tapped
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Item", nil)
                                                            message:NSLocalizedString(@"Enter a name.", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Save", nil),
                                  nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        // configure text field
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.placeholder = NSLocalizedString(@"Name", nil);
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = kAlertViewTextFieldTag;
        [alertView show];
        
        self.insertItemAlertView = alertView;
    }
    
    if (self.deselectSelectedRow)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag >= self.activeItems.count)
        return YES;
    
    id item = self.activeItems[textField.tag];
    [self didChangeItem:item toName:textField.text];
    
    BOOL endEdit = ![self isStringEmpty:textField.text];
    return endEdit;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.insertItemAlertView)
    {
        // insert item alertview
        UITextField *field = [self.insertItemAlertView textFieldAtIndex:0];
        if (field == textField)
        {
            [self.insertItemAlertView dismissWithClickedButtonIndex:1 /* Save button */ animated:YES];
        }
    }
    else
        [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table Management
- (void)insertItemWithName:(NSString *)name animated:(BOOL)animated
{
    [self didInsertItemWithName:name];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.activeItems.count inSection:0];
    UITableViewRowAnimation animationStyle = UITableViewRowAnimationNone;
    if (animated)
        animationStyle = UITableViewRowAnimationFade;
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animationStyle];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)insertItemAnimated:(BOOL)animated
{
    // prevent adding another item, when an empty field is available
    // try to find an empty item name field
    NSUInteger index = [self.tableView.visibleCells indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[CBEditListViewCell class]])
            return NO;
        
        CBEditListViewCell *cell = obj;
        return [self isStringEmpty:cell.textField.text];
    }];
    
    if (index != NSNotFound)
    {
        CBEditListViewCell *cell = (CBEditListViewCell*) self.tableView.visibleCells[index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.textField.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }
    
    [self insertItemWithName:@"" animated:animated];
    
    // Start editing the item's name
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.activeItems.count inSection:0];
    CBEditListViewCell *cell = (CBEditListViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // insert the item
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([self isStringEmpty:textField.text])
            return;
        
        [self insertItemWithName:textField.text animated:YES];
    }
    
    self.insertItemAlertView = nil;
}

@end
