//
//  FileHelpers.c
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 23/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "FileHelpers.h"

/*
 * Borrowed from iPhone Programming, The Big Nerd Ranch Guide
 */

NSString *pathInDocumentDirectory(NSString *fileName){
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *directory = [directories objectAtIndex:0];
    
    return [directory stringByAppendingPathComponent:fileName];
}