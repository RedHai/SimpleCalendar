//
//  SimpleCalendarItemCell.m
//  SimpleCalendar
//
//  Created by hiway on 7/27/13.
//  Copyright (c) 2013 hiway. All rights reserved.
//

#import "SimpleCalendarItemCell.h"

@implementation SimpleCalendarItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickAction:(id)sender {
    
    UIButton *button  = sender;
    [button setBackgroundColor:[UIColor blueColor]];
    
    if ([_delegate respondsToSelector:@selector(simpleCalendarItemCell:buttonIndex:)]) {
        [_delegate simpleCalendarItemCell:self buttonIndex:[sender tag]];
    }
    
    [button performSelector:@selector(setBackgroundColor:) withObject:[UIColor whiteColor] afterDelay:0.5];
    
}
@end
