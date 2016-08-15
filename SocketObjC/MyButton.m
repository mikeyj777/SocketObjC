//
//  MyButton.m
//  SocketObjC
//
//  Created by macuser on 8/14/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//


#import "MyButton.h"

@implementation MyButton

-(id) init
{
    self = [super init];
    
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor blueColor].CGColor];
    
    return self;
}

@end
