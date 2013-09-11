////////////////////////////////////////////////////////////
//
//	RASwipeTableViewCell.h
//  RASwipe Demo
//
//  Created by ऑस्कर लकड़ा on 9/8/13.
//  Copyright (c) 2013 Vertinic Inc. All rights reserved.
//
////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@class RASwipeTableViewCell;

typedef NS_ENUM(NSUInteger, RASwipeTableViewCellContent)
{
	RASwipeTableViewCellPrimaryContent = 0,
	RASwipeTableViewCellSecondaryContent = 1
};

typedef NS_ENUM(NSUInteger, RASwipeTableViewCellDrawer)
{
	RASwipeTableViewCellDrawerOpen = 0,
	RASwipeTableViewCellDrawerClosed
};

@protocol RASwipeTableViewCellDelegate <NSObject>
@optional

@end

@interface RASwipeTableViewCell : UITableViewCell
{
	@protected
	NSArray *_contentViewContainer;
	UISwipeGestureRecognizerDirection _previousDirection;
	
	@private
	UIPanGestureRecognizer *_panGestureRecognizer;
	UISwipeGestureRecognizer *_leftSwipeGestureRecognizer;
	UISwipeGestureRecognizer *_rightSwipeGestureRecognizer;
}

@property (nonatomic, assign) id<RASwipeTableViewCellDelegate> delegate;

@property (nonatomic, assign) RASwipeTableViewCellDrawer drawer;

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic) UISwipeGestureRecognizerDirection direction;

@end