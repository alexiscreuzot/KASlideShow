//
//  ViewController.m
//  KASlideShow
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "ViewController.h"
#import "KASlideShow.h"

@interface ViewController () <KASlideShowDataSource, KASlideShowDelegate>
@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@end

@implementation ViewController{
    NSArray * _datasource;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];

    // UI
    self.startStopButton.layer.cornerRadius = 25;
    self.previousButton.layer.cornerRadius = 25;
    self.nextButton.layer.cornerRadius = 25;
    _speedSlider.alpha = .5;
    [_speedSlider setUserInteractionEnabled:NO];

    _datasource = @[[UIImage imageNamed:@"test_1.jpg"],
                    [NSURL URLWithString:@"https://i.imgur.com/7jDvjyt.jpg"],
                    @"test_3.jpg"];
    
    // KASlideshow
    _slideshow.datasource = self;
    _slideshow.delegate = self;
    [_slideshow setDelay:1]; // Delay between transitions
    [_slideshow setTransitionDuration:.5]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
}

#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return _datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return _datasource.count;
}

#pragma mark - KASlideShow delegate

- (void) slideShowWillShowNext:(KASlideShow *)slideShow
{
    NSLog(@"slideShowWillShowNext, index : %@",@(slideShow.currentIndex));
}

- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"slideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
    NSLog(@"slideShowDidShowNext, index : %@",@(slideShow.currentIndex));
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"slideShowDidShowPrevious, index : %@",@(slideShow.currentIndex));
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
