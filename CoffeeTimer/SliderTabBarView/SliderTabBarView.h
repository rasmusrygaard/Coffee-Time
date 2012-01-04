//
//  SliderTabBarView.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "BrewMethod.h"
#import "Constants.h"

@interface SliderTabBarView : UIView {
    UIImageView *background;
    UIImageView *slider;
    
    UILabel *preparationLabel;
    UILabel *equipmentLabel;
    UILabel *instructionsLabel;
    
    NSArray *tabs;
    
    int oldIndex;
    
    NSMutableArray *accessibleElements;
}

- (NSString *)tabTitleForTouch:(UITouch *)t;
- (void)updateDisplayForTab:(NSString *)tab 
                  forMethod:(BrewMethod *)method;

/* Function: - (void)slideTabToIndex:(int)index;
 * Slide the slider to the tab given by index with animation
 */
 
- (void)slideTabToIndex:(int)index;

//@property (nonatomic, retain) NSMutableArray *_accessibleElements;

@end
