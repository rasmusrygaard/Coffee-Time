//
//  AddMethodView.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddMethodView.h"

@implementation AddMethodView

@synthesize equipmentField, instructionsHints;

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

-(void)dealloc
{
    [equipmentField release];
}

@end
