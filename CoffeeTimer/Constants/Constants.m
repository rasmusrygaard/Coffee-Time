//
//  Constants.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants

int const TIMER_UPDATE_INTERVAL = 0.1;

// SliderTabBarView constants
double const SLIDER_TAB_BAR_X = 11.0;
double const SLIDER_TAB_BAR_Y = 160.0;
double const SLIDER_TAB_BAR_W = 298.0;
double const SLIDER_TAB_BAR_H = 48.0;

// Duration of the slider animation in seconds
double const SLIDER_DURATION = 0.3;

// Dimentsions and locations of the info window in bmViewController
double const INFO_WINDOW_X = 11.0;
double const INFO_WINDOW_Y = 208.0;
double const INFO_WINDOW_W = 298.0;
double const INFO_WINDOW_H = 164.0;

// Inset for text in the SliderTabBarView
double const TABBAR_INSET = 1.0;
double const TEXTFIELD_WIDTH = 100.0;
double const TEXTFIELD_HEIGHT = 49;

// Constants for determining the height of cells in infotableView.
double const MIN_CELL_HEIGHT = 44;
double const CELL_INSET = 10;

// The height of a cell in BrewMethodListViewController
double const LIST_CELL_HEIGHT = 88;

// Width of text in infoTableView cell
double const INFO_CELL_WIDTH = 240;

// AddMethodViewController constants
double const ADD_METHOD_SECTIONS = 2;
double const ADD_METHOD_UPPER_ROWS = 4;
double const ADD_METHOD_LOWER_ROWS = 2;

double const MAX_TEXTFIELD_TAG = 15;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
