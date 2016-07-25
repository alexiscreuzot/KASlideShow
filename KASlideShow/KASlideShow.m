//
//  KASlideShow.m
//

#import "KASlideShow.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kSwipeTransitionDuration 0.25 // default timing

typedef NS_ENUM(NSInteger, KASlideShowSlideMode) {
    KASlideShowSlideModeForward,
    KASlideShowSlideModeBackward
};

@interface KASlideShow()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@property (strong,nonatomic) UIImageView * topImageView;
@property (strong,nonatomic) UIImageView * bottomImageView;
@end

@implementation KASlideShow

@synthesize delegate;
@synthesize delay;
@synthesize transitionDuration;
@synthesize transitionType;

#pragma mark - Inits

- (void)awakeFromNib
{
    [self setDefaultValues];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    // Do not reposition the embedded imageViews.
    frame.origin.x = 0;
    frame.origin.y = 0;

    _topImageView.frame = frame;
    _bottomImageView.frame = frame;
}

- (void) setDefaultValues
{
    self.clipsToBounds = YES;
    _currentIndex = 0;
    delay = 3;

    transitionDuration = 1;
    transitionType = KASlideShowTransitionFade;
    _doStop = YES;
    _isAnimating = NO;

    _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bottomImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _topImageView.autoresizingMask = _bottomImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _topImageView.clipsToBounds = YES;
    _bottomImageView.clipsToBounds = YES;
    [self setImagesContentMode:UIViewContentModeScaleAspectFit];

    [_bottomImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_bottomImageView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":_bottomImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":_bottomImageView}]];

    [_topImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_topImageView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":_topImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":_topImageView}]];

    _topImageView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Get / Set

- (UIImage*) imageForPosition:(KASlideShowPosition)position {
    return (position == KASlideShowPositionTop) ? _topImageView.image : _bottomImageView.image;
}

- (KASlideShowState)state
{
    return !_doStop;
}

- (void) setImagesContentMode:(UIViewContentMode)mode
{
    _topImageView.contentMode = mode;
    _bottomImageView.contentMode = mode;
}

- (UIViewContentMode) imagesContentMode
{
    return _topImageView.contentMode;
}

- (void)setDatasource:(id<KASlideShowDataSource>)datasource
{
    _datasource = datasource;

    if ([self.datasource slideShowImagesNumber:self]>0) {
        [self populateImageView:_topImageView andIndex:0];

        if ([self.datasource slideShowImagesNumber:self]>1) {
            [self populateImageView:_bottomImageView andIndex:1];
        }
    }
}

- (void) populateImageView:(UIImageView*) imageView andIndex:(NSUInteger) index
{
    NSObject * dataObj = [self.datasource slideShow:self objectAtIndex:index];
    if ([dataObj isKindOfClass:[UIImage class]])
    {
        UIImage * image = (UIImage *) dataObj;
        imageView.image = image;
    } else if ([dataObj isKindOfClass:[NSString class]])
    {
        NSString * imageName = (NSString *) dataObj;
        imageView.image = [UIImage imageNamed:imageName];
    } else if ([dataObj isKindOfClass:[NSURL class]])
    {
        NSURL * imageURL = (NSURL *) dataObj;
        [imageView sd_setImageWithURL:imageURL];
    } else {
        [NSException raise:@"Invalid type" format:@"KASlideShow only allow UIImage, NSString or NSURL"];
    }
}

#pragma mark - Actions

- (void) start
{
    _doStop = NO;
    [self next];
}

- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

- (void) next
{
    if (!self.window) return;

    if(! _isAnimating && (self.datasource && [self.datasource slideShowImagesNumber:self] >1)) {

        if ([self.delegate respondsToSelector:@selector(slideShowWillShowNext:)]) [self.delegate slideShowWillShowNext:self];

        // Next Image
        NSUInteger nextIndex = (_currentIndex+1)%[self.datasource slideShowImagesNumber:self];
        [self populateImageView:_topImageView andIndex:_currentIndex];
        [self populateImageView:_bottomImageView andIndex:nextIndex];
        _currentIndex = nextIndex;

        // Animate
        switch (transitionType) {
            case KASlideShowTransitionFade:
                [self animateFade];
                break;

            case KASlideShowTransitionSlideHorizontal:
                [self animateSlideHorizontal:KASlideShowSlideModeForward];
                break;

            case KASlideShowTransitionSlideVertical:
                [self animateSlideVertical:KASlideShowSlideModeForward];
                break;

        }

        // Call delegate
        if([delegate respondsToSelector:@selector(slideShowDidShowNext:)]){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, transitionDuration * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (self.window){
                    [delegate slideShowDidShowNext:self];
                }
            });
        }
    }
}

- (void) previous
{
    if (!self.window) return;

    if(! _isAnimating && (self.datasource && [self.datasource slideShowImagesNumber:self] >1)) {

        if ([self.delegate respondsToSelector:@selector(slideShowWillShowPrevious:)]) [self.delegate slideShowWillShowPrevious:self];

        // Previous image
        NSUInteger prevIndex;
        if(_currentIndex == 0){
            prevIndex = [self.datasource slideShowImagesNumber:self] - 1;
        }else{
            prevIndex = (_currentIndex-1)%[self.datasource slideShowImagesNumber:self];
        }
        [self populateImageView:_topImageView andIndex:_currentIndex];
        [self populateImageView:_bottomImageView andIndex:prevIndex];
        _currentIndex = prevIndex;


        // Animate
        switch (transitionType) {
            case KASlideShowTransitionFade:
                [self animateFade];
                break;

            case KASlideShowTransitionSlideHorizontal:
                [self animateSlideHorizontal:KASlideShowSlideModeBackward];
                break;

            case KASlideShowTransitionSlideVertical:
                [self animateSlideVertical:KASlideShowSlideModeBackward];
                break;
        }

        // Call delegate
        if([delegate respondsToSelector:@selector(slideShowDidShowPrevious:)]){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, transitionDuration * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (self.window){
                    [delegate slideShowDidShowPrevious:self];
                }
            });
        }
    }

}

#pragma mark - Animation logic

- (void) animateFade
{
    _isAnimating = YES;

    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         _topImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){

                         _topImageView.image = _bottomImageView.image;
                         _topImageView.alpha = 1;

                         _isAnimating = NO;

                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}

- (void) animateSlideHorizontal:(KASlideShowSlideMode) mode
{
    _isAnimating = YES;

    if(mode == KASlideShowSlideModeBackward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(- _bottomImageView.frame.size.width, 0);
    }else if(mode == KASlideShowSlideModeForward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(_bottomImageView.frame.size.width, 0);
    }

    [UIView animateWithDuration:transitionDuration
                     animations:^{

                         if(mode == KASlideShowSlideModeBackward){
                             _topImageView.transform = CGAffineTransformMakeTranslation( _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }else if(mode == KASlideShowSlideModeForward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(- _topImageView.frame.size.width, 0);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                     }
                     completion:^(BOOL finished){

                         _topImageView.image = _bottomImageView.image;
                         _topImageView.transform = CGAffineTransformMakeTranslation(0, 0);

                         _isAnimating = NO;

                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}

- (void) animateSlideVertical:(KASlideShowSlideMode) mode
{
    _isAnimating = YES;

    if(mode == KASlideShowSlideModeBackward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(0,- _bottomImageView.frame.size.height);
    }else if(mode == KASlideShowSlideModeForward){
        _bottomImageView.transform = CGAffineTransformMakeTranslation(0,_bottomImageView.frame.size.height);
    }


    [UIView animateWithDuration:transitionDuration
                     animations:^{

                         if(mode == KASlideShowSlideModeBackward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(0, _topImageView.frame.size.height);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }else if(mode == KASlideShowSlideModeForward){
                             _topImageView.transform = CGAffineTransformMakeTranslation(0, - _topImageView.frame.size.height);
                             _bottomImageView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                     }
                     completion:^(BOOL finished){

                         _topImageView.image = _bottomImageView.image;
                         _topImageView.transform = CGAffineTransformMakeTranslation(0, 0);

                         _isAnimating = NO;

                         if(! _doStop){
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                     }];
}

#pragma mark - Gesture Recognizers initializers

- (void) addGesture:(KASlideShowGestureType)gestureType
{
    [self removeGestures];

    switch (gestureType)
    {
        case KASlideShowGestureTap:
            [self addGestureTap];
            break;
        case KASlideShowGestureSwipe:
            [self addGestureSwipe];
            break;
        case KASlideShowGestureAll:
            [self addGestureTap];
            [self addGestureSwipe];
            break;
        default:
            break;
    }
}

- (void) removeGestures
{
    self.gestureRecognizers = nil;
}

- (void) addGestureTap
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) addGestureSwipe
{
    if(self.transitionType == KASlideShowTransitionSlideHorizontal){
        UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

        [self addGestureRecognizer:swipeLeftGestureRecognizer];
        [self addGestureRecognizer:swipeRightGestureRecognizer];
    }else{
        UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

        [self addGestureRecognizer:swipeUpGestureRecognizer];
        [self addGestureRecognizer:swipeDownGestureRecognizer];
    }

}

#pragma mark - Gesture Recognizers handling

- (void)handleSingleTap:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint pointTouched = [gesture locationInView:self.topImageView];

    if (pointTouched.x <= self.topImageView.center.x){
        [self previous];
    }else {
        [self next];
    }
}

- (void) handleSwipe:(id)sender
{
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)sender;

    float oldTransitionDuration = self.transitionDuration;

    self.transitionDuration = kSwipeTransitionDuration;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft ||
        gesture.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self next];
        if ([self.delegate respondsToSelector:@selector(slideShowDidSwipeLeft:)]) {
            [self.delegate slideShowDidSwipeLeft:self];
        }
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight ||
             gesture.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self previous];
        if ([self.delegate respondsToSelector:@selector(slideShowDidSwipeRight:)]) {
            [self.delegate slideShowDidSwipeRight:self];
        }
    }

    self.transitionDuration = oldTransitionDuration;
}

@end
