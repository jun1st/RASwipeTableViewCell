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

typedef NS_ENUM(NSUInteger, RASwipeTableViewCellDirection)
{
	RASwipeTableViewCellDirectionLeft = 0,
	RASwipeTableViewCellDirectionRight
};

typedef NS_ENUM(NSUInteger, RASwipeTableViewCellMode)
{
	RASwipeTableViewCellPrimaryMode = 0,
	RASwipeTableViewCellSecondaryMode
};

@protocol RASwipeTableViewCellDelegate <NSObject>

@optional

- (void)swipeTableViewCell:(RASwipeTableViewCell *)cell withMode:(RASwipeTableViewCellMode)mode;

- (void)swipeTableViewCell:(RASwipeTableViewCell *)cell withMode:(RASwipeTableViewCellMode)mode forDirection:(RASwipeTableViewCellDirection)direction;

@end

@interface RASwipeTableViewCell : UITableViewCell
{
	NSArray *_contentViewContainer;
	
	UISwipeGestureRecognizer *_swipeRightToLeftGestureRecognizer;
	UISwipeGestureRecognizer *_swipeLeftToRightGestureRecognizer;
}

@property (nonatomic, assign) id<RASwipeTableViewCellDelegate> delegate;

@property (nonatomic, assign) RASwipeTableViewCellMode mode;

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic) UISwipeGestureRecognizerDirection direction;

@end
