//
//  SliderTabBarView.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BrewMethod.h"
#import "InfoTableViewController.h"
#import "Constants.h"

@interface SliderTabBarView : UIView {
    UIImage *background;
    UIImageView *slider;
    InfoTableViewController *infoTable;
    
    UILabel *preparationLabel;
    UILabel *equipmentLabel;
    UILabel *instructionsLabel;
    
    NSArray *tabs;
    
    int oldIndex;
}

- (NSString *)tabTitleForTouch:(UITouch *)t;
- (void)updateDisplayForTab:(NSString *)tab 
                  forMethod:(BrewMethod *)method;
- (void)slideTabToIndex:(int)index;

-(double) xCoordForRectAtIndex:(int)index;
- (void)styleLabel:(UILabel *)label;

- (void)drawLabel:(UILabel *)label 
          atIndex:(int)index
        fromPoint:(CGPoint)pt;

@end
