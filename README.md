#KASlideShow

Ultra-basic slideshow for iOS (ARC only). Support manual or automatic slideshow, with fade and slide transitions.

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

    [_slideshow setImages:myImagesMutableArray]; // Provide your own NSMutableArray of UIImage
    [_slideshow addImage:[UIImage imageNamed:@"myImage.jpeg"]]; // Transition duration


###Use of a slideshow

    [_slideshow next]; // Go to the next image
    [_slideshow previous]; // Got to the previous image

    [_slideshow start]; // Start automatic slideshow
    [_slideshow stop]; // Stop automatic slideshow

### KASlideShowDelegate

Don't forget to set the delegate !

    _slideshow.delegate = self;

###Two delegate methods are provided

    - (void)kaSlideShowDidNext
    {
        NSLog(@"Next image");
    }

    -(void)kaSlideShowDidPrevious
    {
        NSLog(@"Previous image");
    }

##Result

![Demo screenshot](http://i.imgur.com/QIuoD9P.gif)


##Support a fellow developer !
If this code helped you for your project, consider contributing or donating some BTC to `1A37Am7UsJZYdpVGWRiye2v9JBthQrYw9N`
Thanks !
