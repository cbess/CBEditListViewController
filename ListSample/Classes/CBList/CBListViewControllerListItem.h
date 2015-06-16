//
//  CBListViewControllerListItem.h
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#ifndef ListSample_CBListViewControllerListItem_h
#define ListSample_CBListViewControllerListItem_h

#import <Foundation/Foundation.h>

@protocol CBListViewControllerListItem <NSObject>

/// The name used to display the text in the list.
- (NSString *)displayTitle;

/// The subtitle displayed in the list.
- (NSString *)displayDetailTitle;

@end

#endif
