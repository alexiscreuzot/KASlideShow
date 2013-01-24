# KASlideShow

Ultra-basic slideshow for iOS (ARC only). 

## How to install

Simply copy : 
 * KASlideShow.h
 * KASlideShow.m

into your project folder and import KASlideShow.h

or use cocoapod with this line :
    pod 'KASlideShow', :git => 'https://github.com/kirualex/KASlideShow.git'

## How to use

    [_slideshow setDelay:3]; // Delay between transitions
    [_slideshow setTransitionDuration:1];
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFit];
    [_slideshow addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]];
    [_slideshow start];

And to stop
    
    [_slideshow stop];


Enjoy !