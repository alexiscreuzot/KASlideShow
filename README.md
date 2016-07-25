#KASlideShow

Slideshow for iOS. Easy to use. Support manual or automatic slideshow, with fade and slide transitions. 
Support local and remote images.

![Demo screenshot](http://i.imgur.com/xTyqOtO.gif)


##version 3.0.0 changelog

This version introduces a lot of breaking changes. Make sure to have a look at the demo.

- Usage is now centered around the `datasource` protocol. 
- Changed `datasource` and `delegate` protocols methods for more consistency
- Introducing the long awaited remote image handling! Just put a valid image NSURL into your `datasource` and you're all set. 

##Install

###Normal install

Simply copy into your project folder :

 * KASlideShow.h
 * KASlideShow.m


###Using [cocoapods](http://cocoapods.org)

add this line to your Podfile :
`pod 'KASlideShow'`

##Usage

###Quick example

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    _datasource = @[[UIImage imageNamed:@"test_1.jpg"],
                    [NSURL URLWithString:@"https://i.imgur.com/7jDvjyt.jpg"],
                    @"test_3.jpg"];

    _slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0,0,320,250)];
    _slideshow.datasource = self;
    _slideshow.delegate = self;
    [_slideshow setDelay:3]; // Delay between transitions
    [_slideshow setTransitionDuration:1]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type 
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
```

### KASlideShowDataSource

You need to implement the datasource to display images.
KASlideShow can handle `UIImage`, `NNString` (name of local image) and `NSURL` (URL of remote image).

```objective-c
- (NSObject *) slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index;
- (NSUInteger) slideShowImagesNumber:(KASlideShow *)slideShow;
```

###Use of a slideshow

```objective-c
[_slideshow next]; // Go to the next image
[_slideshow previous]; // Got to the previous image
[_slideshow start]; // Start automatic slideshow
[_slideshow stop]; // Stop automatic slideshow
```

### KASlideShowDelegate

```objective-c
- (void) slideShowDidShowNext:(KASlideShow *) slideShow;
- (void) slideShowDidShowPrevious:(KASlideShow *) slideShow;
- (void) slideShowWillShowNext:(KASlideShow *) slideShow;
- (void) slideShowWillShowPrevious:(KASlideShow *) slideShow;
- (void) slideShowDidSwipeLeft:(KASlideShow *) slideShow;
- (void) slideShowDidSwipeRight:(KASlideShow *) slideShow;
```

#### Transitions

Here are the 3 available types of transitions you can set via `setTransitionType`.

```
    KASlideShowTransitionFade
    KASlideShowTransitionSlideHorizontal
    KASlideShowTransitionSlideVertical
```

You can furthermore specify the transition duration via `setTransitionDuration`.

#### Gestures

Two types gestures are available to interact with the slideshow via the `addGesture` method. It is possible to add them both.

```
    KASlideShowTransitionFade
    KASlideShowTransitionSlideHorizontal
    KASlideShowTransitionSlideVertical
```
