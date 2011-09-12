//
//  SliderTabBarView.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SliderTabBarView.h"

@implementation SliderTabBarView

- (id)initWithFrame:(CGRect)frame
{
    tabs = [[NSArray alloc] initWithObjects:@"Preparation", @"Instructions", @"Equipment", nil];
    oldIndex = -1;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    
    // Tab bar
    // Get image, draw in context at upper left corner
    background = [UIImage imageNamed:@"TabBar.png"];
    
    CGPoint upperLeft = CGPointMake(bounds.origin.x, bounds.origin.y);
    [background drawAtPoint:upperLeft];

    [self setBackgroundColor:[UIColor clearColor]];
    
    // Get center of TabBar image
    CGPoint center = CGPointMake(upperLeft.x + background.size.width / 2.0,
                                 upperLeft.y + background.size.height / 2.0);
    
    // Draw slider at center of TabBar 
    UIImage *sliderImg = [UIImage imageNamed:@"Slider.png"];
    slider = [[UIImageView alloc] initWithImage:sliderImg];
    
    // Get upper left corner of slider
    CGPoint sliderUpperLeft = CGPointMake(center.x - sliderImg.size.width / 2.0,
                                          upperLeft.x + 1);
    [slider setFrame:CGRectMake(sliderUpperLeft.x, 
                                sliderUpperLeft.y,
                                sliderImg.size.width,
                                sliderImg.size.height)];
    [self addSubview:slider];
    
    // Draw text
    // PreparationLabel
    [self drawLabel:preparationLabel  
            atIndex:0
          fromPoint:upperLeft];
    
    // EquipmentLabel
    [self drawLabel:instructionsLabel 
            atIndex:1
          fromPoint:upperLeft];
    
    [self drawLabel:equipmentLabel
            atIndex:2
          fromPoint:upperLeft];
    
    // Info Window
//    infoTable = [[InfoTableViewController alloc] init];
  //  [self addSubview:infoTable];
    
    /*[[UITableView alloc] init];
    infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    infoTable.rowHeight = 44;
    infoTable.backgroundColor = [UIColor clearColor];
    
    infoBackground = [UIImage imageNamed:@"InfoWindow.png"];
    
    CGPoint infoUpperLeft = upperLeft;
    infoUpperLeft.y += background.size.height - 2;
    infoUpperLeft.x += 1;
    [infoBackground drawAtPoint:infoUpperLeft];
     */

}

- (void)drawLabel:(UILabel *)label 
          atIndex:(int)index 
        fromPoint:(CGPoint)pt
{
    CGRect rect = CGRectMake([self xCoordForRectAtIndex:index], 
                             pt.y, 
                             TEXTFIELD_WIDTH, 
                             TEXTFIELD_HEIGHT);
    
    label = [[UILabel alloc] initWithFrame:rect];
    
    NSString *text = [tabs objectAtIndex:index];
    [label setText:text];
    [self styleLabel:label];
    [self addSubview:label];
    [label release];
}

- (void)styleLabel:(UILabel *)label
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
    [label setFont:font];
    [label setTextColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.9]];
    
    // Text shadow
    label.layer.shadowOpacity = 0.8;
    label.layer.shadowRadius = 1;
    label.layer.shadowOffset = CGSizeMake(0, .5);
    label.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    [label setBackgroundColor:[UIColor clearColor]];
    
    [label setTextAlignment:UITextAlignmentCenter];

}

// Return x coordinate for left edge of text rectangle at index

-(double) xCoordForRectAtIndex:(int)index
{
    return TABBAR_INSET + index * TEXTFIELD_WIDTH;
}

/* - (NSString *)tabTitleForTouch:(UITouch *)t
 * Return the title of the tab located under the UITouch
 */

- (NSString *)tabTitleForTouch:(UITouch *)t
{
    int index = [t locationInView:self].x / TEXTFIELD_WIDTH;
    return [tabs objectAtIndex:index];
}

/* - (void)updateDisplayForTab:(NSString *)tab
 * Update the tab bar so that the slider is positioned at the tab with the name $tab.
 * Update the info window to display information corresponding to the tab (ie. information 
 * for the instructions tab).
 */

- (void)updateDisplayForTab:(NSString *)tab forMethod:(BrewMethod *)method
{
    int index = [tabs indexOfObject:tab];

    if (index != oldIndex) {
        [self slideTabToIndex:index];
//        [self displayInfo:(NSString *)tab 
//                forMethod:(BrewMethod *)method];
        
        oldIndex = index;
    }
}

- (void)slideTabToIndex:(int)index
{
    CGRect oldFrame = [slider frame];   
    double x = [self xCoordForRectAtIndex:index];
    
    CGRect newFrame = CGRectMake(x - index, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    
    // Set up sliding animation
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    [move setDuration:0.3 ];
    [move setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [move setRemovedOnCompletion:YES];
    
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2.0 - index, 
                                                             oldFrame.origin.y + oldFrame.size.height / 2.0)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(x + oldFrame.size.width / 2.0 - index - 1, 
                                                           oldFrame.origin.y + oldFrame.size.height / 2.0)]];
    
    [[slider layer] addAnimation:move forKey:@"moveAnimation"];
    [slider setFrame:newFrame];
}

/*
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    CGRect oldFrame = [slider frame];   
    
    int index = p.x / TEXTFIELD_WIDTH;
    double x = [self xCoordForRectAtIndex:index];
    
    CGRect newFrame = CGRectMake(x - index, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    
    // Set up sliding animation
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    [move setDuration:0.3 ];
    [move setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [move setRemovedOnCompletion:YES];
    
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2.0 - index, 
                                                             oldFrame.origin.y + oldFrame.size.height / 2.0)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(x + oldFrame.size.width / 2.0 - index - 1, 
                                                           oldFrame.origin.y + oldFrame.size.height / 2.0)]];
    
    [[slider layer] addAnimation:move forKey:@"moveAnimation"];
    [slider setFrame:newFrame];
}*/

- (void)dealloc
{
    [preparationLabel release];
    [equipmentLabel release];
    [instructionsLabel release];
    
    [background release];
    [slider release];
    
    [tabs release];
    
    [super dealloc];
}


@end
