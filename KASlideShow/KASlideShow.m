//
//  KASlideShow.m
//
// Copyright 2013 Alexis Creuzot
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "KASlideShow.h"
#import <AVFoundation/AVFoundation.h>

#define kSwipeTransitionDuration 0.25

typedef NS_ENUM(NSInteger, KASlideShowSlideMode) {
  KASlideShowSlideModeForward,
  KASlideShowSlideModeBackward
};
@interface KASlideShow()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@property (strong,nonatomic) UIView * topView;
@property (strong,nonatomic) UIView * bottomView;
@property (nonatomic) MPMoviePlayerController *topViewMoviePlayerController;
@property (nonatomic) MPMoviePlayerController *bottomViewMoviePlayerController;

@end


@implementation KASlideShow

@synthesize delegate;
@synthesize delay;
@synthesize transitionDuration;
@synthesize transitionType;
@synthesize media;

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
  
  _topView.frame = frame;
  _bottomView.frame = frame;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  if (!CGRectEqualToRect(self.bounds, _topView.bounds)) {
    _topView.frame = self.bounds;
  }
  
  if (!CGRectEqualToRect(self.bounds, _bottomView.bounds)) {
    _bottomView.frame = self.bounds;
  }
}

- (void) setDefaultValues
{
  self.clipsToBounds = YES;
  self.media = [NSMutableArray array];
  _currentIndex = 0;
  delay = 3;
  
  transitionDuration = 1;
  transitionType = KASlideShowTransitionFade;
  _doStop = YES;
  _isAnimating = NO;
  
  _topView = [[UIView alloc] initWithFrame:self.bounds];
  _bottomView = [[UIView alloc] initWithFrame:self.bounds];
  _topView.autoresizingMask = _bottomView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  _topView.clipsToBounds = YES;
  _bottomView.clipsToBounds = YES;
  
  [self setImagesContentMode:UIViewContentModeScaleAspectFit];
  
  [self addSubview:_bottomView];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":_bottomView}]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":_bottomView}]];
  
  [self addSubview:_topView];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":_topView}]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":_topView}]];
  
  // create the movie player controller
  self.bottomViewMoviePlayerController = [MPMoviePlayerController new];
  self.topViewMoviePlayerController = [MPMoviePlayerController new];
  
  self.topViewMoviePlayerController.view.frame = _topView.frame;
  self.topViewMoviePlayerController.repeatMode = MPMovieRepeatModeOne;
  self.topViewMoviePlayerController.controlStyle = MPMovieControlStyleNone;
  [_topView addSubview:self.topViewMoviePlayerController.view];
  self.topViewMoviePlayerController.view.alpha = 0;
  self.topViewMoviePlayerController.view.userInteractionEnabled = false;
  [_topView sendSubviewToBack:self.topViewMoviePlayerController.view];
  
  self.bottomViewMoviePlayerController.view.frame = _bottomView.frame;
  self.bottomViewMoviePlayerController.repeatMode = MPMovieRepeatModeOne;
  self.bottomViewMoviePlayerController.controlStyle = MPMovieControlStyleNone;
  [_bottomView addSubview:self.bottomViewMoviePlayerController.view];
  self.bottomViewMoviePlayerController.view.alpha = 0;
  self.bottomViewMoviePlayerController.view.userInteractionEnabled = false;
  
  [_bottomView sendSubviewToBack:self.bottomViewMoviePlayerController.view];
  
  
}

- (void) setImagesContentMode:(UIViewContentMode)mode
{
  _topView.contentMode = mode;
  _bottomView.contentMode = mode;
}

- (UIViewContentMode) imagesContentMode
{
  return _topView.contentMode;
}

- (void) addGesture:(KASlideShowGestureType)gestureType
{
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

- (void) addImagesFromResources:(NSArray *) names
{
  for(NSString * name in names){
    [self addImage:[UIImage imageNamed:name]];
  }
}

- (void) addMediaFromResources:(NSArray *) names
{
  for(id name in names){
    if (![name isKindOfClass:[NSURL class]]){
      [self addImage:[UIImage imageNamed:(NSString*)name]];
    }else {
      
      [self addVideoWithURL:(NSURL*)name];
    }
  }
}


- (void) setImagesDataSource:(NSMutableArray *)array {
  self.media = array;
  [_topView setBackgroundColor:[UIColor colorWithPatternImage:[array firstObject]]];
}

- (void) addImage:(UIImage*) image
{
  [self.media addObject:image];
  
  if([self.media count] == 1){
    [_topView setBackgroundColor:[UIColor colorWithPatternImage:image]];
  }else if([self.media count] == 2){
    [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:image]];
  }
}

- (void) addVideoWithURL:(NSURL*) url
{
  [self.media addObject:url];
  
  if([self.media count] == 1){
    self.topViewMoviePlayerController.view.alpha = 1;
    self.topViewMoviePlayerController.contentURL = url;
    [self.topViewMoviePlayerController play];
  }else if([self.media count] == 2){
    self.bottomViewMoviePlayerController.view.alpha = 1;
    self.bottomViewMoviePlayerController.contentURL = url;
  }
}


- (void) emptyAndAddImagesFromResources:(NSArray *)names
{
  [self.media removeAllObjects];
  _currentIndex = 0;
  [self addImagesFromResources:names];
}

- (void) start
{
  _doStop = NO;
  [self next];
}

- (void) next
{
  if(! _isAnimating && ([self.media count] >1 || self.dataSource)) {
    
    if ([self.delegate respondsToSelector:@selector(kaSlideShowWillShowNext:)]) [self.delegate kaSlideShowWillShowNext:self];
    
    // Next Image
    if (self.dataSource) {
      [_topView setBackgroundColor:[UIColor colorWithPatternImage:[self.dataSource slideShow:self imageForPosition:KASlideShowPositionTop]]];
      [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:[self.dataSource slideShow:self imageForPosition:KASlideShowPositionBottom]]];
    } else {
      NSUInteger nextIndex = (_currentIndex+1)%[self.media count];
      if (![self isVideoItemAtIndex:(int)_currentIndex]){
        self.topViewMoviePlayerController.view.alpha = 0;
        [_topView setBackgroundColor:[UIColor colorWithPatternImage:self.media[_currentIndex]]];
      }else {
        self.topViewMoviePlayerController.view.alpha = 1;
        [self.topViewMoviePlayerController stop];
        self.topViewMoviePlayerController.contentURL = self.media[_currentIndex];
      }
      
      if (![self isVideoItemAtIndex:(int)nextIndex]){
        self.bottomViewMoviePlayerController.view.alpha = 0;
        [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:self.media[nextIndex]]];
      }else {
        self.bottomViewMoviePlayerController.view.alpha = 1;
        [self.bottomViewMoviePlayerController stop];
        self.bottomViewMoviePlayerController.contentURL = self.media[nextIndex];
      }
      
      _currentIndex = nextIndex;
    }
    
    // Animate
    switch (transitionType) {
      case KASlideShowTransitionFade:
        [self animateFade];
        break;
        
      case KASlideShowTransitionSlide:
        [self animateSlide:KASlideShowSlideModeForward];
        break;
        
    }
    
    // Call delegate
    if([delegate respondsToSelector:@selector(kaSlideShowDidShowNext:)]){
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, transitionDuration * NSEC_PER_SEC);
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [delegate kaSlideShowDidShowNext:self];
      });
    }
  }
}

- (void) previous
{
  if(! _isAnimating && ([self.media count] >1 || self.dataSource)){
    
    if ([self.delegate respondsToSelector:@selector(kaSlideShowWillShowPrevious:)]) [self.delegate kaSlideShowWillShowPrevious:self];
    
    // Previous image
    if (self.dataSource) {
      [_topView setBackgroundColor:[UIColor colorWithPatternImage:[self.dataSource slideShow:self imageForPosition:KASlideShowPositionTop]]];
      [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:[self.dataSource slideShow:self imageForPosition:KASlideShowPositionBottom]]];
    } else {
      NSUInteger prevIndex;
      if(_currentIndex == 0){
        prevIndex = [self.media count] - 1;
      }else{
        prevIndex = (_currentIndex-1)%[self.media count];
      }
      
      if (![self isVideoItemAtIndex:(int)_currentIndex]){
        self.topViewMoviePlayerController.view.alpha = 0;
        [_topView setBackgroundColor:[UIColor colorWithPatternImage:self.media[_currentIndex]]];
      }else {
        self.topViewMoviePlayerController.view.alpha = 1;
        [self.topViewMoviePlayerController stop];
        self.topViewMoviePlayerController.contentURL = self.media[_currentIndex];
      }
      
      if (![self isVideoItemAtIndex:(int)prevIndex]){
        //the element is an Image
        self.bottomViewMoviePlayerController.view.alpha = 0;
        [_bottomView setBackgroundColor:[UIColor colorWithPatternImage:self.media[prevIndex]]];
      }else {
        //
        self.bottomViewMoviePlayerController.view.alpha = 1;
        [self.bottomViewMoviePlayerController stop];
        self.bottomViewMoviePlayerController.contentURL = self.media[prevIndex];
      }
      _currentIndex = prevIndex;
    }
    
    // Animate
    switch (transitionType) {
      case KASlideShowTransitionFade:
        [self animateFade];
        break;
        
      case KASlideShowTransitionSlide:
        [self animateSlide:KASlideShowSlideModeBackward];
        break;
    }
    
    // Call delegate
    if([delegate respondsToSelector:@selector(kaSlideShowDidShowPrevious:)]){
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, transitionDuration * NSEC_PER_SEC);
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [delegate kaSlideShowDidShowPrevious:self];
      });
    }
  }
  
}

- (void) animateFade
{
  _isAnimating = YES;
  
  [UIView animateWithDuration:transitionDuration
                   animations:^{
                     _topView.alpha = 0;
                   }
                   completion:^(BOOL finished){
                     
                     if (self.bottomViewMoviePlayerController.view.alpha == 0){
                       //an image is displayed there.
                       self.topViewMoviePlayerController.view.alpha = 0;
                       [_topView setBackgroundColor:_bottomView.backgroundColor];
                     }else {
                       //a video is displayed
                       self.topViewMoviePlayerController.view.alpha = 1;
                       [self.bottomViewMoviePlayerController stop];
                       [self.topViewMoviePlayerController stop];
                       self.topViewMoviePlayerController.contentURL = self.bottomViewMoviePlayerController.contentURL;
                       [self.topViewMoviePlayerController play];
                     }
                     
                     _topView.alpha = 1;
                     
                     _isAnimating = NO;
                     
                     if(! _doStop){
                       if (self.topViewMoviePlayerController.view.alpha == 1){
                         AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.media[_currentIndex] options:nil];

                         [self performSelector:@selector(next) withObject:nil afterDelay:CMTimeGetSeconds(asset.duration)];
                       }else {
                         [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                       }
                     }
                   }];
}

- (void) animateSlide:(KASlideShowSlideMode) mode
{
  _isAnimating = YES;
  
  if(mode == KASlideShowSlideModeBackward){
    _bottomView.transform = CGAffineTransformMakeTranslation(- _bottomView.frame.size.width, 0);
  }else if(mode == KASlideShowSlideModeForward){
    _bottomView.transform = CGAffineTransformMakeTranslation(_bottomView.frame.size.width, 0);
  }
  
  
  [UIView animateWithDuration:transitionDuration
                   animations:^{
                     
                     if(mode == KASlideShowSlideModeBackward){
                       _topView.transform = CGAffineTransformMakeTranslation( _topView.frame.size.width, 0);
                       _bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }else if(mode == KASlideShowSlideModeForward){
                       _topView.transform = CGAffineTransformMakeTranslation(- _topView.frame.size.width, 0);
                       _bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                   }
                   completion:^(BOOL finished){
                     if (self.bottomViewMoviePlayerController.view.alpha == 0){
                       //an image is displayed there.
                       self.topViewMoviePlayerController.view.alpha = 0;
                       [_topView setBackgroundColor:_bottomView.backgroundColor];
                     }else {
                       //a video is displayed
                       self.topViewMoviePlayerController.view.alpha = 1;
                       [self.bottomViewMoviePlayerController stop];
                       [self.topViewMoviePlayerController stop];
                       self.topViewMoviePlayerController.contentURL = self.bottomViewMoviePlayerController.contentURL;
                       [self.topViewMoviePlayerController play];
                     }
                     _topView.transform = CGAffineTransformMakeTranslation(0, 0);
                     
                     _isAnimating = NO;
                     
                     
                     if(! _doStop){
                       [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
                       if (self.topViewMoviePlayerController.view.alpha == 1){
                         AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.media[_currentIndex] options:nil];
                         
                         [self performSelector:@selector(next) withObject:nil afterDelay:CMTimeGetSeconds(asset.duration)];
                       }else {
                         [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                       }
                     }
                   }];
}


- (void) stop
{
  _doStop = YES;
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

- (KASlideShowState)state
{
  return !_doStop;
}

#pragma mark - Gesture Recognizers initializers
- (void) addGestureTap
{
  UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  
  singleTapGestureRecognizer.numberOfTapsRequired = 1;
  [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void) addGestureSwipe
{
  UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
  swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  
  UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
  swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  
  [self addGestureRecognizer:swipeLeftGestureRecognizer];
  [self addGestureRecognizer:swipeRightGestureRecognizer];
}

#pragma mark - Gesture Recognizers handling
- (void)handleSingleTap:(id)sender
{
  UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
  CGPoint pointTouched = [gesture locationInView:self.topView];
  
  if (pointTouched.x <= self.topView.center.x){
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
  if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
  {
    [self next];
  }
  else if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
  {
    [self previous];
  }
  
  self.transitionDuration = oldTransitionDuration;
}

-(BOOL)isVideoItemAtIndex:(int)index {
  return [self.media[index] isKindOfClass:[NSURL class]];
}

- (void) stopVideos {
  if (self.topViewMoviePlayerController.view.alpha == 1){
    //the topView is playing some video then let's stop it
    [self.topViewMoviePlayerController stop];
  }
}

- (void) startVideos {
  if (self.topViewMoviePlayerController.view.alpha == 1){
    //the topView is playing some video then let's start it
    [self.topViewMoviePlayerController play];
  }
}


@end

