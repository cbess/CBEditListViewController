//
//  SampleItem.m
//  ListSample
//
//  Created by C. Bess on 6/15/15.
//  Copyright (c) 2015 C. Bess. All rights reserved.
//

#import "SampleItem.h"

@implementation SampleItem

+ (instancetype)itemWithName:(NSString *)name subtitle:(NSString *)subtitle {
    SampleItem *item = [self new];
    item.name = name;
    item.subtitle = subtitle;
    return item;
}

- (NSString *)displayTitle {
    return self.name;
}

- (NSString *)displayDetailTitle {
    return self.subtitle;
}

@end
