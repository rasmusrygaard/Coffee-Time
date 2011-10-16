//
//  SliderTabBarView.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 09/09/11.
//  
//  This class represents a tab bar with a slider. For now, the class 
//

#import "SliderTabBarView.h"

@implementation SliderTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tabs = [[NSArray alloc] initWithObjects:@"Preparation", @"Instructions", @"Equipment", nil];
        oldIndex = -1;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    
    // Get image, draw in context at upper left corner
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabBackground.png"]];
    [background setContentMode:UIViewContentModeScaleAspectFill];
    
    [background setFrame:CGRectMake(bounds.origin.x, bounds.origin.y, SLIDER_TAB_BAR_W, SLIDER_TAB_BAR_H)];

    [self addSubview:background];
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGPoint upperLeft = CGPointMake(bounds.origin.x, bounds.origin.y);
    
    // Get center of TabBar image
    CGPoint center = CGPointMake(upperLeft.x + background.frame.size.width / 2.0,
                                 upperLeft.y + background.frame.size.height / 2.0);
    
    // Draw slider at center of TabBar 
    UIImage *sliderImg = [UIImage imageNamed:@"Slider.png"];
    slider = [[UIImageView alloc] initWithImage:sliderImg];
    
    // Get upper left corner of slider
    CGPoint sliderUpperLeft = CGPointMake(center.x - sliderImg.size.width / 2.0,
                                          upperLeft.x + 2);
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
    
    // instructionsLabel
    [self drawLabel:instructionsLabel 
            atIndex:1
          fromPoint:upperLeft];
    
    // equipmentLabel
    [self drawLabel:equipmentLabel
            atIndex:2
          fromPoint:upperLeft];

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
    // Font
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [label setFont:font];
    [label setTextColor:[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1]];
    
    // Shadow
    label.shadowColor = [UIColor darkTextColor];
    label.shadowOffset = CGSizeMake(0, 1);
      
    [label setBackgroundColor:[UIColor clearColor]];
    
    [label setTextAlignment:UITextAlignmentCenter];

}

// Return x coordinate for left edge of text rectangle at index

-(double) xCoordForRectAtIndex:(int)index
{
    return index * TEXTFIELD_WIDTH;
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
        
        
        oldIndex = index;
    }
}

- (void)slideTabToIndex:(int)index
{
    CGRect oldFrame = [slider frame];   
    double x = [self xCoordForRectAtIndex:index];
    
    CGRect newFrame = CGRectMake(x + index, 
                                 oldFrame.origin.y,
                                 oldFrame.size.width, 
                                 oldFrame.size.height);
    
    // Set up sliding animation
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    [move setDuration:SLIDER_DURATION];
    [move setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [move setRemovedOnCompletion:YES];
    
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2.0 - index, 
                                                             oldFrame.origin.y + oldFrame.size.height / 2.0)]];
    
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(x + oldFrame.size.width / 2.0, 
                                                           oldFrame.origin.y + oldFrame.size.height / 2.0)]];
    
    [[slider layer] addAnimation:move forKey:@"moveAnimation"];
    
    // Move the slider to the new position after the animation
    [slider setFrame:newFrame];
}


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
