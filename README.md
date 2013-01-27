# KASlideShow

Ultra-basic slideshow for iOS (ARC only). Support manual or automatic slideshow, with fade and slide transitions.

## How to install

### Normal install

Simply copy into your project folder :

 * KASlideShow.h
 * KASlideShow.m


### Using cocoapod

add this line to your Podfile :

    pod 'KASlideShow', :git => 'https://github.com/kirualex/KASlideShow.git'

## Quick start

### Creation of a slideshow

    _slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0,0,320,250)];
    [_slideshow setDelay:3]; // Delay between transitions
    [_slideshow setTransitionDuration:1]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]]; // Add images from resources

### Other methods to add images

    [_slideshow setImages:myImagesMutableArray]; // Provide your own NSMutableArray of UIImage
    [_slideshow addImage:[UIImage imageNamed:@"myImage.jpeg"]]; // Transition duration


### Use of a slideshow

    [_slideshow next]; // Go to the next image
    [_slideshow previous]; // Got to the previous image

    [_slideshow start]; // Start automatic slideshow
    [_slideshow stop]; // Stop automatic slideshow

## KASlideShowDelegate

### You can use the delegate by first declaring its target

    _slideshow.delegate = self;

### Two delegate methods are provided

    - (void)kaSlideShowDidNext
    {
        NSLog(@"Next image");
    }

    -(void)kaSlideShowDidPrevious
    {
        NSLog(@"Previous image");
    }

## Demo screenshot

![Demo screenshot](http://s9.postimage.org/68sqfbu7j/Capture_d_cran_du_Simulateur_i_OS_27_janv_2013.png)

## Misc

Do not hesitate to report any bug/issues or missing functionalities. I'm also open to any pull request that can improve this project further !