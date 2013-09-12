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
	RASwipeTableViewCellSecondaryContent,
	RASwipeTableViewCellTernaryContent
};

typedef NS_ENUM(NSUInteger, RASwipeTableViewCellDrawer)
{
	RASwipeTableViewCellDrawerOpen = 0,
	RASwipeTableViewCellDrawerClosed
};

typedef NS_ENUM(NSUInteger, RASwipeTableViewCellDirection)
{
	RASwipeTableViewCellDirectionToLeft = 0,
	RASwipeTableViewCellDirectionToRight,
	RASwipeTableViewCellDirectionToCenter
};

@protocol RASwipeTableViewCellDelegate <NSObject>
@optional

@end

@interface RASwipeTableViewCell : UITableViewCell
{
	@protected
	NSArray *_contentViewContainer;
	RASwipeTableViewCellDirection _previousDirection;
	
	@private
	UIPanGestureRecognizer *_panGestureRecognizer;
	UISwipeGestureRecognizer *_leftSwipeGestureRecognizer;
	UISwipeGestureRecognizer *_rightSwipeGestureRecognizer;
}

@property (nonatomic, assign) id<RASwipeTableViewCellDelegate> delegate;

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) RASwipeTableViewCellDirection direction;

@property (nonatomic, readonly) RASwipeTableViewCellDrawer drawer;

@property (nonatomic, readonly) BOOL isDragging;

@end