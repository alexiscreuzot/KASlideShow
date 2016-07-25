//
//  KASlideShow.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KASlideShowTransitionType) {
    KASlideShowTransitionFade,
    KASlideShowTransitionSlideVertical,
    KASlideShowTransitionSlideHorizontal
};

typedef NS_ENUM(NSInteger, KASlideShowGestureType) {
    KASlideShowGestureTap,
    KASlideShowGestureSwipe,
    KASlideShowGestureAll
};

typedef NS_ENUM(NSUInteger, KASlideShowPosition) {
    KASlideShowPositionTop,
    KASlideShowPositionBottom
};

typedef NS_ENUM(NSUInteger, KASlideShowState) {
    KASlideShowStateStopped,
    KASlideShowStateStarted
};

@class KASlideShow;
@protocol KASlideShowDelegate <NSObject>
@optional
- (void) slideShowDidShowNext:(KASlideShow *) slideShow;
- (void) slideShowDidShowPrevious:(KASlideShow *) slideShow;
- (void) slideShowWillShowNext:(KASlideShow *) slideShow;
- (void) slideShowWillShowPrevious:(KASlideShow *) slideShow;
- (void) slideShowDidSwipeLeft:(KASlideShow *) slideShow;
- (void) slideShowDidSwipeRight:(KASlideShow *) slideShow;
@end

@protocol KASlideShowDataSource <NSObject>
@required
- (NSObject *) slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index;
- (NSUInteger) slideShowImagesNumber:(KASlideShow *)slideShow;
@end

@interface KASlideShow : UIView

@property (nonatomic, unsafe_unretained) IBOutlet id<KASlideShowDataSource> datasource;
@property (nonatomic, unsafe_unretained) IBOutlet id<KASlideShowDelegate> delegate;

@property float delay;
@property float transitionDuration;
@property (atomic) KASlideShowTransitionType transitionType;
@property (atomic) UIViewContentMode imagesContentMode;

@property  (readonly, nonatomic) NSUInteger currentIndex;
@property  (readonly, nonatomic) KASlideShowState state;

- (void) addGesture:(KASlideShowGestureType)gestureType;
- (void) removeGestures;

- (void) start;
- (void) stop;
- (void) previous;
- (void) next;

@end

