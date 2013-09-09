////////////////////////////////////////////////////////////
//
//	RASwipeTableViewCell.m
//  RASwipe Demo
//
//  Created by ऑस्कर लकड़ा on 9/8/13.
//  Copyright (c) 2013 Vertinic Inc. All rights reserved.
//
////////////////////////////////////////////////////////////

#import "RASwipeTableViewCell.h"

@implementation RASwipeTableViewCell

#pragma mark - Memory management methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Private methods

- (void)initialize
{
	_mode = RASwipeTableViewCellPrimaryMode;
	
	CGRect frame = self.contentView.frame;
	
	if(!_contentViewContainer) {
		_contentViewContainer = [NSArray arrayWithObjects:
								 [[UIView alloc] initWithFrame:frame],
								 [[UIView alloc] initWithFrame:frame],
								 nil];
	}
	
	for(UIView *_view in _contentViewContainer) {
		[self.contentView addSubview:_view];
	}
	
	[self.contentView bringSubviewToFront:(UIView *)[_contentViewContainer objectAtIndex:_mode]];
}

@end
