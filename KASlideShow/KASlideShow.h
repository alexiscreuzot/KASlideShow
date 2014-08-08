//
//  KASlideShow.h
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

typedef NS_ENUM(NSInteger, KASlideShowTransitionType) {
    KASlideShowTransitionFade,
    KASlideShowTransitionSlide
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
- (void) kaSlideShowDidNext:(KASlideShow *) slideShow;
- (void) kaSlideShowDidPrevious:(KASlideShow *) slideShow;
- (void) kaSlideShowWillShowNext:(KASlideShow *) slideShow;
- (void) kaSlideShowWillShowPrevious:(KASlideShow *) slideShow;
@end

@protocol KASlideShowDataSource <NSObject>
- (UIImage *)slideShow:(KASlideShow *)slideShow imageForPosition:(KASlideShowPosition)position;
@end

@interface KASlideShow : UIView

@property (nonatomic, unsafe_unretained) IBOutlet id <KASlideShowDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<KASlideShowDataSource> dataSource;

@property  float delay;
@property  float transitionDuration;
@property  (readonly, nonatomic) NSUInteger currentIndex;
@property  (atomic) KASlideShowTransitionType transitionType;
@property  (atomic) UIViewContentMode imagesContentMode;
@property  (strong,nonatomic) NSMutableArray * images;
@property  (readonly, nonatomic) KASlideShowState state;

- (void) addImagesFromResources:(NSArray *) names;
- (void) emptyAndAddImagesFromResources:(NSArray *)names;
- (void) setImagesDataSource:(NSMutableArray *)array;
- (void) addGesture:(KASlideShowGestureType)gestureType;
- (void) addImage:(UIImage *) image;
- (void) start;
- (void) stop;
- (void) previous;
- (void) next;

@end

