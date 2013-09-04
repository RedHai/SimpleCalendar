//
//  SimpleCalendarDay.m
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import "SimpleCalendarDay.h"

@implementation SimpleCalendarDay

-(id)init {
    
    self = [super init];
    if (self) {
        _number = 0;
        _enabled = YES;
        _marketType = MARKETED_TYPE_NONE;
    }
    
    return self;
}

@end
