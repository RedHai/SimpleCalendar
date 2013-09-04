SimpleCalendar
==============

A simple calendar for ios

Usage

    NSDate *beginDate = [NSDate date];
    
    SimpleCalendar *calendarView = [[SimpleCalendar alloc] initWithBeginDate:beginDate selectedDate:beginDate numsOfDay:60];
    calendarView.delegate = self;
    
    [self.view addSubview:calendarView];

