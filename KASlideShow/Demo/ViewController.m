//
//  ViewController.m
//  KASlideShow
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "ViewController.h"
#import "KASlideShow.h"

@interface ViewController ()


@end

@implementation ViewController{
    KASlideShow * slideshow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0,20, 320, 150)];
    [self.view addSubview:slideshow];
    
    [slideshow addImageFromNames:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]];
    [slideshow setDelay:1];
    [slideshow setTransitionDuration:1];
    
}

- (IBAction)start:(id)sender
{
    [slideshow start];
}

- (IBAction)stop:(id)sender
{
    [slideshow stop];
}


@end
