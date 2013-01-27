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
@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slideshow.delegate = self;
    [_slideshow setDelay:3]; // Delay between transitions
    [_slideshow setTransitionDuration:1]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]]; // Add images from resources
}

#pragma mark - KASlideShow delegate

- (void)kaSlideShowDidNext
{
    NSLog(@"kaSlideShowDidNext");
}

-(void)kaSlideShowDidPrevious
{
    NSLog(@"kaSlideShowDidPrevious");
}

#pragma mark - Button methods

- (IBAction)previous:(id)sender
{
    [_slideshow previous];
}

- (IBAction)next:(id)sender
{
    [_slideshow next];
}

- (IBAction)startStrop:(id)sender
{
    UIButton * button = (UIButton *) sender;
    
    if([button.titleLabel.text isEqualToString:@"Start"]){
        [_slideshow start];
        [button setTitle:@"Stop" forState:UIControlStateNormal];
    }else{
        [_slideshow stop];
        [button setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (IBAction)switchType:(id)sender
{
    UIButton * button = (UIButton *) sender;
    
    if([button.titleLabel.text isEqualToString:@"Fade"]){
        [_slideshow setTransitionType:KASlideShowTransitionFade];
        [button setTitle:@"Slide" forState:UIControlStateNormal];
    }else{
        [_slideshow setTransitionType:KASlideShowTransitionSlide];
        [button setTitle:@"Fade" forState:UIControlStateNormal];
    }
}

@end
