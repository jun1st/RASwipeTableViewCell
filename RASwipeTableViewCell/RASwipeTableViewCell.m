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

@interface RASwipeTableViewCell (PrivateMethods) <UIGestureRecognizerDelegate>

- (void)initialize;

// Handle Gestures
- (void)handleSwipeLeftToRightGestureRecognizer:(UISwipeGestureRecognizer *)gesture;
- (void)handleSwipeRightToLeftGestureRecognizer:(UISwipeGestureRecognizer *)gesture;

@end

@implementation RASwipeTableViewCell (PrivateMethods)

#pragma mark - Private methods

- (void)initialize
{
	self.mode = RASwipeTableViewCellPrimaryMode;
	
	if(!_contentViewContainer) {
		CGRect frame = self.contentView.frame;
		_contentViewContainer = [NSArray arrayWithObjects:
								 [[UIView alloc] initWithFrame:frame],
								 [[UIView alloc] initWithFrame:frame],
								 nil];
	}
	NSUInteger idx = 0;
	for(UIView *_view in _contentViewContainer) {
		_view.tag = idx++;
		_view.clipsToBounds = YES;
		_view.opaque = YES;
		if (_view.tag == 0) {
			_view.backgroundColor = [UIColor lightGrayColor];
		} else {
			_view.backgroundColor = [UIColor darkGrayColor];
		}
		[self.contentView addSubview:_view];
	}
	[self.contentView bringSubviewToFront:(UIView *)[_contentViewContainer objectAtIndex:0]];
	
	if(!_swipeLeftToRightGestureRecognizer) {
		_swipeLeftToRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftToRightGestureRecognizer:)];
		_swipeLeftToRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		_swipeLeftToRightGestureRecognizer.delegate = self;
	}
	[self addGestureRecognizer:_swipeLeftToRightGestureRecognizer];
	
	if(!_swipeRightToLeftGestureRecognizer) {
		_swipeRightToLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightToLeftGestureRecognizer:)];
		_swipeRightToLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		_swipeRightToLeftGestureRecognizer.delegate = self;
	}
	[self addGestureRecognizer:_swipeRightToLeftGestureRecognizer];
}

- (void)handleSwipeLeftToRightGestureRecognizer:(UISwipeGestureRecognizer *)gesture
{
	NSLog(@"Received swipe left-to-right gesture notification");
	self.mode = RASwipeTableViewCellPrimaryMode;
	
}

- (void)handleSwipeRightToLeftGestureRecognizer:(UISwipeGestureRecognizer *)gesture
{
	NSLog(@"Received swipe right-to-left gesture notification");
	self.mode = RASwipeTableViewCellSecondaryMode;
	
	if(_contentViewContainer && [_contentViewContainer count] == 2) {
		CGRect frame = self.contentView.frame;
		CGFloat leftOffset = CGRectGetWidth(frame) * 0.10;
			
		UIView *primaryView = [_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryMode];
		
		[UIView animateWithDuration:1.0 animations:^{
			primaryView.frame = CGRectMake(0, 0, leftOffset, CGRectGetHeight(frame));
		}];
	}
}

@end

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

#pragma mark - View management methods

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.contentView.frame;
	
	for(UIView *_view in _contentViewContainer)
		_view.frame = frame;
}

#pragma mark - UIGestureRecognizerDelegate methods

/*! Called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. 
 * 
 * returning NO causes it to transition to UIGestureRecognizerStateFailed
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	// only interested in the UISwipeGestureRecognizer
	return ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])? YES : NO;
}

@end
