//
//  SimpleCalendarDay.h
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

typedef enum{

    MARKETED_TYPE_NONE = 0,
    MARKETED_TYPE_CURRENT_DATE = 1,
    MARKETED_TYPE_SELECTED_DATE = 2
    
}MarkedType;

#import <Foundation/Foundation.h>

@interface SimpleCalendarDay : NSObject

@property (assign, nonatomic) NSUInteger number;

@property (strong, nonatomic) NSDate *date;

@property (assign, nonatomic) BOOL enabled;

@property (assign, nonatomic) MarkedType marketType;

@end
