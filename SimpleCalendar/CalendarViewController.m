//
//  CalendarViewController.m
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import "CalendarViewController.h"
#import "SimpleCalendar.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"CalendarView";
    
    [self performSelectorInBackground:@selector(initCalendarView) withObject:nil];

    
}

- (void) initCalendarView {
    
    NSDate *beginDate = [NSDate date];
    
    SimpleCalendar *calendarView = [[SimpleCalendar alloc] initWithBeginDate:beginDate selectedDate:beginDate numsOfDay:60];
    calendarView.delegate = self;
    
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)simpleCalendar:(SimpleCalendar *)calendar pickUpDate:(NSDate *)date {
    NSLog(@"date : %@", date);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
