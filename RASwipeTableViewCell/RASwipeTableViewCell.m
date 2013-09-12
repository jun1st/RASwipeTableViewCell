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
- (void)handleTowardsLeftPanGestureRecognizer: (UIPanGestureRecognizer *)gesture;
- (void)handleTowardsRightPanGestureRecognizer: (UIPanGestureRecognizer *)gesture;
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
								 [[UIView alloc] initWithFrame:frame],
								 nil];
		NSUInteger idx = 0;
		for(UIView *_view in _contentViewContainer) {
			_view.tag = idx++;
			_view.clipsToBounds = YES;
			_view.hidden = YES;
			switch (_view.tag) {
				case RASwipeTableViewCellPrimaryContent:
					_view.backgroundColor = [UIColor lightGrayColor];
					_view.hidden = NO;
					break;
					
				case RASwipeTableViewCellSecondaryContent:
					_view.backgroundColor = [UIColor redColor];
					break;
					
				case RASwipeTableViewCellTernaryContent:
					_view.backgroundColor = [UIColor yellowColor];
					break;
			}
		}
	}
		
	for(UIView *_view in _contentViewContainer)
		[self.contentView addSubview:_view];
	
	[self.contentView bringSubviewToFront:(UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent]];
	
	if(!_panGestureRecognizer) {
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
		_panGestureRecognizer.delegate = self;
		[self addGestureRecognizer:_panGestureRecognizer];
	}
}

- (void)handlePanGestureRecognizer: (UIPanGestureRecognizer *)gesture
{
	UIGestureRecognizerState state = gesture.state;
	
	if(state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
		_isDragging = YES;
	}
	
	else if(state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
		_isDragging = NO;
		
		CGPoint velocity = [gesture velocityInView:self];
		if(velocity.x > 0) {
			[self handleTowardsRightPanGestureRecognizer:gesture];
		} else {
			[self handleTowardsLeftPanGestureRecognizer:gesture];
		}
	}
}

- (void)handleTowardsLeftPanGestureRecognizer: (UIPanGestureRecognizer *)gesture
{
	if(_drawer == RASwipeTableViewCellDrawerClosed) {
		_drawer = RASwipeTableViewCellDrawerOpen;
		_previousDirection = RASwipeTableViewCellDirectionToLeft;
		
		UIView *_secondaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellSecondaryContent];
		CGRect frame = self.contentView.frame;
		_secondaryView.frame = CGRectMake(CGRectGetWidth(frame), frame.origin.y, frame.size.width, frame.size.height);
		_secondaryView.hidden = NO;
		
		[UIView animateWithDuration:0.5f animations:^{
			CGRect primaryFrame = self.contentView.frame;
			primaryFrame.origin.x -= _offset;
			
			UIView *primaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
			primaryView.frame = primaryFrame;
			
			CGRect secondaryFrame = self.contentView.frame;
			secondaryFrame.origin.x = _offset;
			UIView *secondaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellSecondaryContent];
			secondaryView.frame = secondaryFrame;
			
		} completion:^(BOOL finished) {
			NSLog(@"open drawer towards left");
		}];
	}
	else if(_drawer == RASwipeTableViewCellDrawerOpen
			&& _previousDirection != RASwipeTableViewCellDirectionToLeft) {
		
		_drawer = RASwipeTableViewCellDrawerClosed;
		
		[UIView animateWithDuration:0.5f animations:^{
			CGRect primaryFrame = self.contentView.frame;
			
			UIView *primaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
			primaryView.frame = primaryFrame;
			
			UIView *ternaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellSecondaryContent];
			
			CGRect ternaryFrame = ternaryView.frame;
			ternaryFrame.origin.x -= _offset;
			
			ternaryView.frame = ternaryFrame;
			
		} completion:^(BOOL finished) {
			UIView *ternaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellTernaryContent];
			ternaryView.hidden = NO;
			
			NSLog(@"close drawer towards left");
		}];
	}
}

- (void)handleTowardsRightPanGestureRecognizer: (UIPanGestureRecognizer *)gesture
{
	if(_drawer == RASwipeTableViewCellDrawerClosed) {
		_drawer = RASwipeTableViewCellDrawerOpen;
		_previousDirection = RASwipeTableViewCellDirectionToRight;
		
		UIView *_ternaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellTernaryContent];
		CGRect frame = self.contentView.frame;
		_ternaryView.frame = CGRectMake(CGRectGetWidth(frame) * -1.0f, frame.origin.y, frame.size.width, frame.size.height);
		_ternaryView.hidden = NO;
		
		[UIView animateWithDuration:0.5f animations:^{
			CGRect primaryFrame = self.contentView.frame;
			primaryFrame.origin.x += _offset;
			
			UIView *primaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
			primaryView.frame = primaryFrame;
			
			UIView *ternaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellTernaryContent];
			ternaryView.frame = self.contentView.frame;
			
		} completion:^(BOOL finished) {
			NSLog(@"open drawer towards right");
		}];
	}
	else if(_drawer == RASwipeTableViewCellDrawerOpen
			 && _previousDirection != RASwipeTableViewCellDirectionToRight) {
		
		_drawer = RASwipeTableViewCellDrawerClosed;
		
		[UIView animateWithDuration:0.5f animations:^{
			CGRect primaryFrame = self.contentView.frame;
			UIView *primaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellPrimaryContent];
			primaryView.frame = primaryFrame;
			
			UIView *secondaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellSecondaryContent];
			
			CGRect secondaryFrame = secondaryView.frame;
			secondaryFrame.origin.x = CGRectGetWidth(self.contentView.frame);
			
			secondaryView.frame = secondaryFrame;
			
		} completion:^(BOOL finished) {
			UIView *secondaryView = (UIView *)[_contentViewContainer objectAtIndex:RASwipeTableViewCellSecondaryContent];
			secondaryView.hidden = NO;
			
			NSLog(@"close drawer towards right");
		}];
	}
}

@end