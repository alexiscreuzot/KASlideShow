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
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];

    // UI
    self.startStopButton.layer.cornerRadius = 25;
    self.previousButton.layer.cornerRadius = 25;
    self.nextButton.layer.cornerRadius = 25;
    _speedSlider.alpha = .5;
    [_speedSlider setUserInteractionEnabled:NO];
    
    // KASlideshow
    _slideshow.delegate = self;
    [_slideshow setDelay:1]; // Delay between transitions
    [_slideshow setTransitionDuration:.5]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addImagesFromResources:@[@"test_1.jpg",@"test_2.jpg",@"test_3.jpg"]]; // Add images from resources
    [_slideshow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
    
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

- (IBAction)selectChangeValue:(id)sender
{
    UISlider * slider = (UISlider *) sender;
    [_slideshow setDelay:@(slider.value).floatValue/10]; // Delay between transitions
}

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
        _speedSlider.alpha = 1;
        [_speedSlider setUserInteractionEnabled:YES];
        [_slideshow start];
        [button setTitle:@"■" forState:UIControlStateNormal];
    }else{
        _speedSlider.alpha = .5;
        [_speedSlider setUserInteractionEnabled:NO];
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
    }else if(control.selectedSegmentIndex == 1){
        [_slideshow setTransitionType:KASlideShowTransitionSlideHorizontal];
        _slideshow.gestureRecognizers = nil;
        [_slideshow addGesture:KASlideShowGestureSwipe];
    }else if(control.selectedSegmentIndex == 2){
        [_slideshow setTransitionType:KASlideShowTransitionSlideVertical];
        _slideshow.gestureRecognizers = nil;
        [_slideshow addGesture:KASlideShowGestureSwipe];
    }
}

@end
