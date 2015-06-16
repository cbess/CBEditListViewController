//
//  SampleItem.h
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBListViewControllerListItem.h"

@interface SampleItem : NSObject <CBListViewControllerListItem>

+ (instancetype)itemWithName:(NSString *)name subtitle:(NSString *)subtitle;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subtitle;

@end
