//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by Junnebai on 13-12-24.
//  Copyright (c) 2013年 GirliOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

@end
