//
//  ViewController.m
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import "ViewController.h"
#import "SimpleCalendar.h"
#import "CalendarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title  = @"MainView";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calendarViewAction:(id)sender {
    
    CalendarViewController *controller = [[CalendarViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
