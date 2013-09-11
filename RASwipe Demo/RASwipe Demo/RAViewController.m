////////////////////////////////////////////////////////////
//
//	RAViewController.m
//  RASwipe Demo
//
//  Created by ऑस्कर लकड़ा on 9/8/13.
//  Copyright (c) 2013 Vertinic Inc. All rights reserved.
//
////////////////////////////////////////////////////////////

#import "RAViewController.h"

#import "RASwipeTableViewCell.h"

#define DEMO_CELL_HEIGHT	80.0

@interface RAViewController ()

@end

@implementation RAViewController

#pragma mark - Memory management methods

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if( self ) {
		self->_contentItems = 5;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - View management methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"RASwipe Table View";
	
	[self.tableView setBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _contentItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"RASwipe_Demo_Cell_Identifier";
	
	RASwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(!cell) {
		cell = [[RASwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	switch (indexPath.row) {
		case 0:
			cell.direction = UISwipeGestureRecognizerDirectionRight;
			cell.offset = CGRectGetWidth(cell.frame) * 0.50;
			break;
			
		case 1:
			cell.direction = UISwipeGestureRecognizerDirectionRight;
			cell.offset = CGRectGetWidth(cell.frame) * 0.50;
			break;
			
		case 2:
			cell.direction = UISwipeGestureRecognizerDirectionLeft;
			cell.offset = CGRectGetWidth(cell.frame) * 0.50;
			break;
	}
	

	[cell.contentView setBackgroundColor:[UIColor whiteColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return DEMO_CELL_HEIGHT;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end