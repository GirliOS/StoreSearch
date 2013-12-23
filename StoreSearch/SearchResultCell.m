//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by Junnebai on 13-12-24.
//  Copyright (c) 2013年 GirliOS. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

@synthesize nameLabel;
@synthesize artistNameLabel;
@synthesize artworkImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"TableCellGradient"];;
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:image];
    self.backgroundView = backgroundImageView;
    
    UIImage *selectedImage = [UIImage imageNamed:@"SelectedTableCellGradient"];
    UIImageView *selectedBackgroundImageView = [[UIImageView alloc] initWithImage:selectedImage];
    self.selectedBackgroundView = selectedBackgroundImageView;
}

@end
