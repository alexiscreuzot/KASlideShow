#KASlideShow

Ultra-basic slideshow for iOS (ARC only). Support manual or automatic slideshow, with fade and slide transitions.

![Demo screenshot](http://i.imgur.com/I1164Xc.gif)

##Install

###Normal install

Simply copy into your project folder :

 * KASlideShow.h
 * KASlideShow.m


###Using [cocoapods](http://cocoapods.org)

add this line to your Podfile :
`pod 'KASlideShow'`

##Usage

###Creation of a slideshow

    _slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0,0,320,250)];
    [_slideshow setDelay:3]; // Delay between transitions
    [_slideshow setTransitionDuration:1]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]]; // Add images from resources

###Other methods to add images

   - (void) addImagesFromResources:(NSArray *) names;
   - (void) emptyAndAddImagesFromResources:(NSArray *)names;
   - (void) addImage:(UIImage *) image;

###Use of a slideshow

    [_slideshow next]; // Go to the next image
    [_slideshow previous]; // Got to the previous image

    [_slideshow start]; // Start automatic slideshow
    [_slideshow stop]; // Stop automatic slideshow

### KASlideShowDataSource

You can also implement this protocol to use the slideshow in a more memory efficient way.

    - (UIImage *)slideShow:(KASlideShow *)slideShow imageForPosition:(KASlideShowPosition)position;
    
    
### KASlideShowDelegate

Don't forget to set the delegate !

    _slideshow.delegate = self;

### Delegate

    - (void) kaSlideShowDidNext:(KASlideShow *) slideShow;
    - (void) kaSlideShowDidPrevious:(KASlideShow *) slideShow;
    - (void) kaSlideShowWillShowNext:(KASlideShow *) slideShow;
    - (void) kaSlideShowWillShowPrevious:(KASlideShow *) slideShow;

