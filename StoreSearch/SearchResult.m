//
//  SearchResult.m
//  StoreSearch
//
//  Created by Junnebai on 13-12-23.
//  Copyright (c) 2013年 GirliOS. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

@synthesize name;
@synthesize artistName;

- (NSComparisonResult)compareName:(SearchResult *)other
{
    return [self.name localizedStandardCompare:other.name];
}

@end
