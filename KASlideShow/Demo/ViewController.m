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
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *transitionTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation ViewController

#pragma mark Initial setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // UI
    self.startStopButton.layer.cornerRadius = 25;
    self.transitionTypeButton.layer.cornerRadius = 25;
    self.previousButton.layer.cornerRadius = 25;
    self.nextButton.layer.cornerRadius = 25;
    
    // KASlideshow
    _slideshow.delegate = self;
    [_slideshow setDelay:1]; // Delay between transitions
    [_slideshow setTransitionDuration:.5]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display







    [self setupSlideshow];
}


//  jdrobert mentioned that his images were transparent--I'll see if I can modify these images' alphas prior to
//  passing them to -addImagesFromResources:



//  Scratch that, I think I'll just set the images' alphas when they are set on their imageViews
//  My suspicion is that the imageViews in this instance have clear backgrounds, or are not opaque
- (void)setupSlideshow {




    [_slideshow addImagesFromResources:@[

                                         @"test_1.png",


                                         @"test_2.jpeg", @"test_3.jpeg"]];
    [self.slideshow addGesture:KASlideShowGestureSwipe];
//    [self.slideshow setTransitionType:KASlideShowTransitionSlide];
}







#pragma mark - KASlideShow delegate

- (void)kaSlideShowWillShowNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowWillShowNext, index : %@",@(slideShow.currentIndex));
}

- (void)kaSlideShowWillShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
}

- (void) kaSlideShowDidShowNext:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidNext, index : %@",@(slideShow.currentIndex));
}

-(void)kaSlideShowDidShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"kaSlideShowDidPrevious, index : %@",@(slideShow.currentIndex));
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
    
    if([button.titleLabel.text isEqualToString:@"▸"]){
        [_slideshow start];
        [button setTitle:@"■" forState:UIControlStateNormal];
    }else{
        [_slideshow stop];
        [button setTitle:@"▸" forState:UIControlStateNormal];
    }
}

- (IBAction)switchType:(id)sender
{
    UISegmentedControl * control = (UISegmentedControl *) sender;
    if(control.selectedSegmentIndex == 0){
        [_slideshow setTransitionType:KASlideShowTransitionFade];
        _slideshow.gestureRecognizers = nil;
        [_slideshow addGesture:KASlideShowGestureTap];
    }else{
        [_slideshow setTransitionType:KASlideShowTransitionSlide];
        _slideshow.gestureRecognizers = nil;
        [_slideshow addGesture:KASlideShowGestureSwipe];
    }
}

@end
