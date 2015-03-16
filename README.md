#KASlideShow

Ultra-basic slideshow for iOS (ARC only). Support manual or automatic slideshow, with fade and slide transitions.

![Demo screenshot](http://fat.gfycat.com/MediocreVillainousBoa.gif)

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

```objective-c
_slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0,0,320,250)];
[_slideshow setDelay:3]; // Delay between transitions
[_slideshow setTransitionDuration:1]; // Transition duration
[_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
[_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
[_slideshow addImagesFromResources:@[@"test_1.jpeg",@"test_2.jpeg",@"test_3.jpeg"]]; // Add images from resources
[_slideshow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
```

###Other methods to add images

```objective-c
- (void) addImagesFromResources:(NSArray *) names;
- (void) emptyAndAddImagesFromResources:(NSArray *)names;
- (void) addImage:(UIImage *) image;
```

###Use of a slideshow

```objective-c
[_slideshow next]; // Go to the next image
[_slideshow previous]; // Got to the previous image

[_slideshow start]; // Start automatic slideshow
[_slideshow stop]; // Stop automatic slideshow
```

### Gestures   

### KASlideShowDataSource

You can also implement this protocol to use the slideshow in a more memory efficient way.

```objective-c
- (UIImage *)slideShow:(KASlideShow *)slideShow imageForPosition:(KASlideShowPosition)position;
```

### KASlideShowDelegate

Don't forget to set the delegate !

```objective-c
_slideshow.delegate = self;
```
### Delegate

```objective-c
- (void) kaSlideShowDidShowNext:(KASlideShow *) slideShow;
- (void) kaSlideShowDidShowPrevious:(KASlideShow *) slideShow;
- (void) kaSlideShowWillShowNext:(KASlideShow *) slideShow;
- (void) kaSlideShowWillShowPrevious:(KASlideShow *) slideShow;
```
