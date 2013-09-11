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

@interface RASwipeTableViewCell () <UIGestureRecognizerDelegate>

- (void)initialize;

// Handle Gestures
- (void)handleTowardsLeftSwipeGestureRecognizer: (UISwipeGestureRecognizer *)gesture;
- (void)handleTowardsRightSwipeGestureRecognizer: (UISwipeGestureRecognizer *)gesture;
- (void)handlePanGestureRecognizer: (UIPanGestureRecognizer *)gesture;

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

#pragma mark - View management methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect frame = self.contentView.frame;
	for(UIView *_view in _contentViewContainer)
		_view.frame = frame;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	_drawer = RASwipeTableViewCellDrawerClosed;
}

#pragma mark - UIGestureRecognizerDelegate methods

/*! Called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. 
 * 
 * returning NO causes it to transition to UIGestureRecognizerStateFailed
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	//
	//return ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])? YES : NO;
	if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *) gestureRecognizer;
		CGPoint point = [gesture velocityInView:self];
		if(fabsf(point.x) > fabsf(point.y))
			return YES;
	}
	
	return NO;
}

#pragma mark - Private methods

- (void)initialize
{
	_drawer = RASwipeTableViewCellDrawerClosed;
	_offset = CGRectGetWidth(self.contentView.frame) * 0.10;
	_direction = UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft;
	_duration = 0.4f;
	
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
	
	if(!_panGestureRecognizer) {
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
		_panGestureRecognizer.delegate = self;
		[self addGestureRecognizer:_panGestureRecognizer];
	}
}

- (void)handlePanGestureRecognizer: (UIPanGestureRecognizer *)gesture
{
	CGPoint point = [gesture velocityInView:self];
	if(point.x > 0) {
		NSLog(@"swiped towards right");
	} else {
		NSLog(@"swiped towards left");
	}
}

- (void)handleTowardsLeftSwipeGestureRecognizer: (UISwipeGestureRecognizer *)gesture
{
	if(_drawer == RASwipeTableViewCellDrawerClosed) {
		_previousDirection = UISwipeGestureRecognizerDirectionLeft;
		
		[UIView animateWithDuration:_duration animations:^{
			UIView *primaryView = [_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
			primaryView.frame = CGRectMake(0.0 - _offset, 0.0f, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
		} completion:^(BOOL finished) {
			NSLog(@"open drawer towards left");
			_drawer = RASwipeTableViewCellDrawerOpen;
		}];
		
	} else {
		if(_previousDirection == UISwipeGestureRecognizerDirectionRight) {
			[UIView animateWithDuration:_duration animations:^{
				UIView *primaryView = [_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
				primaryView.frame = CGRectMake(0.0, 0.0f, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
			} completion:^(BOOL finished) {
				NSLog(@"close drawer towards left");
				_drawer = RASwipeTableViewCellDrawerClosed;
			}];
		}
	}
}

- (void)handleTowardsRightSwipeGestureRecognizer: (UISwipeGestureRecognizer *)gesture
{
	if(_drawer == RASwipeTableViewCellDrawerClosed) {
		_previousDirection = UISwipeGestureRecognizerDirectionRight;
		
		[UIView animateWithDuration:_duration animations:^{
			UIView *primaryView = [_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
			primaryView.frame = CGRectMake(_offset, 0.0f, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
		} completion:^(BOOL finished) {
			NSLog(@"open drawer towards right");
			_drawer = RASwipeTableViewCellDrawerOpen;
		}];
		
	} else {
		if(_previousDirection == UISwipeGestureRecognizerDirectionLeft) {
			[UIView animateWithDuration:_duration animations:^{
				UIView *primaryView = [_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
				primaryView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
			} completion:^(BOOL finished) {
				NSLog(@"close drawer towards right");
				_drawer = RASwipeTableViewCellDrawerClosed;
			}];
		}
		
	}
}

@end
