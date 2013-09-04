//
//  SimpleCalendarItemCell.h
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleCalendarItemCellDelegate;

@interface SimpleCalendarItemCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *itemBtns;
- (IBAction)clickAction:(id)sender;

@property(weak, nonatomic) NSObject<SimpleCalendarItemCellDelegate> *delegate;
@end


@protocol SimpleCalendarItemCellDelegate <NSObject>

-(void)simpleCalendarItemCell:(SimpleCalendarItemCell *)cell buttonIndex:(NSUInteger)index;

@end