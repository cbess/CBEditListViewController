//
//  ViewController.m
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "ViewController.h"
#import "CBEditListViewController.h"
#import "SampleItem.h"

@interface ViewController ()
@property (nonatomic, strong) CBListViewController *listViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listViewController = [CBListViewController new];
    self.listViewController.items = @[
                                      [SampleItem itemWithName:@"One" subtitle:@"This is one."],
                                      [SampleItem itemWithName:@"Two" subtitle:@"This is two."],
                                      [SampleItem itemWithName:@"Three" subtitle:@"This is three."],
                                      [SampleItem itemWithName:@"Four" subtitle:@"This is four."],
                                      [SampleItem itemWithName:@"Five" subtitle:@"This is five."],
                                      ];
    
    [self.listViewController configureCellBlock:^UITableViewCell *(NSIndexPath *indexPath, UITableViewCell *cell) {
        return cell;
    }];
    
    __typeof__(self) __weak weakSelf = self;
    [self.listViewController configureCellSelectedBlock:^(NSIndexPath *indexPath, id item) {
        [weakSelf.listViewController.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}

- (IBAction)listButtonPressed:(id)sender {
    self.listViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.listViewController animated:YES completion:nil];
}

- (IBAction)listBarButtonItemPressed:(id)sender {
    self.listViewController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:self.listViewController animated:YES completion:nil];
    
    // setup the popover use the UIPopoverPresentationController
    UIPopoverPresentationController *popoverCtrl = self.listViewController.popoverPresentationController;
    popoverCtrl.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverCtrl.barButtonItem = sender;
}

@end
