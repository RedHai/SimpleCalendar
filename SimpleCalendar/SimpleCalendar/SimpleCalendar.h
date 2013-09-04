//
//  SimpleCalendar.h
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCalendarItemCell.h"

@protocol SimpleCalendarDelegate;


@interface SimpleCalendar : UIView<UITableViewDataSource,UITableViewDelegate,SimpleCalendarItemCellDelegate> {
    
    NSMutableArray *_dataSource;
    UINib *_cellNib;
    NSDate *_currentPageDate;
}

@property (strong, nonatomic) NSDate *beginDate;
@property (assign, nonatomic) NSUInteger numsOfDay;
@property (strong, nonatomic) NSDate *selectedDate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (SimpleCalendar *)initWithBeginDate:(NSDate *)beginDate selectedDate:(NSDate *)selectedDate numsOfDay:(NSUInteger)numsOfDay;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSObject<SimpleCalendarDelegate> *delegate;

- (IBAction)nextAction:(id)sender;
- (IBAction)prevAction:(id)sender;
@end

@protocol SimpleCalendarDelegate <NSObject>

- (void)simpleCalendar:(SimpleCalendar *)calendar pickUpDate:(NSDate *)date;

@end