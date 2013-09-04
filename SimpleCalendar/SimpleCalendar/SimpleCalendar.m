//
//  SimpleCalendar.m
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import "SimpleCalendar.h"
#import "SimpleCalendarItemCell.h"
#import "SimpleCalendarDay.h"
#import <QuartzCore/QuartzCore.h>

@implementation SimpleCalendar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (SimpleCalendar *)initWithBeginDate:(NSDate *)beginDate selectedDate:(NSDate *)selectedDate numsOfDay:(NSUInteger)numsOfDay {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"SimpleCalendar" owner:self options:nil] objectAtIndex:0];

    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _beginDate = [self zeroDetailTime:beginDate];
    _numsOfDay = numsOfDay;
    _selectedDate = (selectedDate == nil) ? [NSDate date] : selectedDate;
    _selectedDate = [self zeroDetailTime:_selectedDate];
    _currentPageDate = _selectedDate;
    
    if (_beginDate != nil && numsOfDay != 0) {
        
        [self performSelectorInBackground:@selector(initCellNibAndGestureRecognizers) withObject:nil];
        [self performSelectorInBackground:@selector(showCalendarWithDate:) withObject:_selectedDate];
    }

    return self;
}

- (void)respondToSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self prevAction:nil];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextAction:nil];
    }     
}

- (void) initCellNibAndGestureRecognizers {
    
    _cellNib = [UINib nibWithNibName:@"SimpleCalendarItemCell" bundle:nil];
    
    UISwipeGestureRecognizer *swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    [swipeGestureRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeGestureRecognizerLeft];

    UISwipeGestureRecognizer *swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    [swipeGestureRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeGestureRecognizerRight];
}

- (void)showCalendarWithDate:(NSDate *)date {
    
    _titleLabel.text = [NSString stringWithFormat:@"%d年%d月",
                        [self getYearOf:date], [self getMonthof:date]];
    int firstWeekDayInMonth = [self firstWeekDayInMonth:date];
    NSDate *firstDate = [self firstDayInMonth:date];
    int numDaysInMonth = [self numDaysInMonth:date];
    NSDate *endDate = [NSDate dateWithTimeInterval:_numsOfDay*24*60*60 sinceDate:_beginDate];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i != 6; i++) {
        
        NSMutableArray *week = [[NSMutableArray alloc] init];
        BOOL isAllWeekZero = YES;
        
        for (int j = 0; j != 7; j++) {
            SimpleCalendarDay *day = [[SimpleCalendarDay alloc] init];
            
            day.number = (j+1) + (i*7) - firstWeekDayInMonth;
            if (day.number < 1 || day.number > numDaysInMonth) {
                day.date = nil;
                day.number = 0;
                day.enabled = NO;
            } else {
                day.date = [NSDate dateWithTimeInterval:(day.number-1)*24*60*60 sinceDate:firstDate];
                isAllWeekZero = NO;
                
                //whether day.date is valid
                if ([day.date compare:_beginDate] == NSOrderedAscending || [day.date compare:endDate] != NSOrderedAscending) {
                    day.enabled = NO;
                }
                
                if ([day.date compare:[self zeroDetailTime:[NSDate date]]] == NSOrderedSame) {
                    day.marketType = MARKETED_TYPE_CURRENT_DATE;
                
                } else if([day.date compare:_selectedDate] == NSOrderedSame) {
                    day.marketType = MARKETED_TYPE_SELECTED_DATE;
                }
                
            }
            
            [week addObject:day];
        }
        
        if (!isAllWeekZero)
            [data addObject:week];
        
    
    }
    
    _tableView.delegate = nil; _tableView.dataSource = nil;
    _dataSource = data;
    [_tableView reloadData];
    _tableView.delegate = self; _tableView.dataSource = self;
    
}

    
    
    
- (IBAction)nextAction:(id)sender {
    
    NSDate *date = [self firstDayOfNextMonth:_currentPageDate];
    [self showCalendarWithDate:date];
    _currentPageDate = date;
    
}

- (IBAction)prevAction:(id)sender {
    
    NSDate *date = [self firstDayOfPreviousMonth:_currentPageDate];
    [self showCalendarWithDate:date];
    _currentPageDate = date;
}

// UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataSource == nil) {
        return 0;
    }
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleCalendarItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCalendarItemCell"];
    
    if(cell == nil) {
        
        cell = [[_cellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;
        cell.delegate = self;
    
    }
    
                
    if (indexPath.row < _dataSource.count) {
        
        NSArray *week = [_dataSource objectAtIndex:indexPath.row];
        NSArray *itemBtns = cell.itemBtns;
        
        for (int j = 0 ; j != itemBtns.count; j ++) {
            SimpleCalendarDay *day = [week objectAtIndex:j];
            UIButton *btn = [itemBtns objectAtIndex:j];
            NSString *title = @"";
            if (day.number > 0)
                title = [NSString stringWithFormat:@"%d", day.number];
            
                [btn setTitle:title forState:UIControlStateNormal];
                btn.enabled = day.enabled;
                
                if (day.marketType == MARKETED_TYPE_CURRENT_DATE) {
                    [[btn layer] setBorderWidth:0.5f];
                    [[btn layer] setBorderColor:[UIColor lightGrayColor].CGColor];
                } else {
                    [btn.layer setBorderWidth:0];
                }
        }
        
    }
    
    return cell;
}

- (void)simpleCalendarItemCell:(SimpleCalendarItemCell *)cell buttonIndex:(NSUInteger)index {
    
    if (cell.tag < _dataSource.count) {
        NSArray *week = [_dataSource objectAtIndex:cell.tag];
        if (index < week.count) {
            SimpleCalendarDay *day = [week objectAtIndex:index];
            if ([_delegate respondsToSelector:@selector(simpleCalendar:pickUpDate:)]) {
                [_delegate simpleCalendar:self pickUpDate:day.date];
            }
        }
    }
}

// Date methods

-(int)numDaysInMonth:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

- (int)firstWeekDayInMonth:(NSDate *)date {
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    NSDate *firstDate = [self firstDayInMonth:date];
    
    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDate];
}

- (NSDate *)firstDayInMonth:(NSDate *)date {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar
                                    components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    [components setDay:1];
    [self zeroOutTimeComponents:&components];
    
    return [gregorianCalendar dateFromComponents:components];
}

- (NSDate *)firstDayOfPreviousMonth:(NSDate *)date {
    NSDateComponents *minusOneMonthComponent = [[NSDateComponents alloc] init];
	[minusOneMonthComponent setMonth:-1];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *oneMonthAgoToday = [gregorianCalendar dateByAddingComponents:minusOneMonthComponent
                                                                  toDate:date options:0];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                        fromDate:oneMonthAgoToday];
    
    [components setDay:1];
    
    [self zeroOutTimeComponents:&components];
    
    return [gregorianCalendar dateFromComponents:components];
}

- (NSDate *)firstDayOfNextMonth:(NSDate *)date {
    
    NSDate *firstDayOfCurrentMonth = [self firstDayInMonth:date];
    
    NSDateComponents *plusOneMonthComponent = [[NSDateComponents alloc] init];
	[plusOneMonthComponent setMonth:1];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [gregorianCalendar dateByAddingComponents:plusOneMonthComponent
                                              toDate:firstDayOfCurrentMonth
                                             options:0];
}


-(int)getYearOf:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:date];
    return [components year];
}


-(int)getMonthof:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:date];
    return [components month];
}

-(int)getDayOf:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:date];
    return [components day];
}

- (void)zeroOutTimeComponents:(NSDateComponents **)components {
    [*components setHour:0];
    [*components setMinute:0];
    [*components setSecond:0];
}

-(NSDate *)localTime:(NSDate *)date {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate:date];
}

-(NSDate *)zeroDetailTime:(NSDate *)date {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar
                                    components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    [self zeroOutTimeComponents:&components];
    
    return [gregorianCalendar dateFromComponents:components];
    
}

@end














