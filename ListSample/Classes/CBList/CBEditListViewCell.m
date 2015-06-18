//
//  CBEditListViewCell.m
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "CBEditListViewCell.h"

@implementation CBEditListViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // The user can only edit the text field when in editing mode.
    [super setEditing:editing animated:animated];
    
    self.textField.enabled = editing;
}

@end
