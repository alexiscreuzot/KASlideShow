//
//  KASlideShow.m
//
//  Created by Alexis Creuzot on 23/01/13.
//  Copyright (c) 2013 Alexis Creuzot. All rights reserved.
//

#import "KASlideShow.h"

@interface KASlideShow()
@property (atomic) BOOL doStop;
@property (atomic) BOOL isAnimating;
@end

@implementation KASlideShow{
    NSMutableArray * slides;
}

@synthesize delay;
@synthesize transitionDuration;
@synthesize imagesContentMode;

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

- (void) setDefaultValues
{
    slides = [NSMutableArray array];
    delay = 1;
    imagesContentMode = UIViewContentModeScaleAspectFit;
    transitionDuration = 0.3;
    _doStop = YES;
    _isAnimating = NO;
}


- (void) addImagesFromResources:(NSArray *) names
{
    // Add images
    for(NSString * name in names){
        [self addImage:[UIImage imageNamed:name]];
    }
}

- (void) addImage:(UIImage*) image
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.bounds];
    [imageView setContentMode:imagesContentMode];
    
    if([slides count] == 0){
        [self addSubview:imageView];
    }else{
        [self insertSubview:imageView belowSubview:[slides lastObject]];
    }
    [slides addObject:imageView];
}


- (void) start
{
    
    if([slides count] <= 1){
        return;
    }
    
    
    _doStop = NO;
    [self performSelector:@selector(next) withObject:nil afterDelay:delay];
}

- (void) next
{
    if(_isAnimating){
        return;
    }
    
    _isAnimating = YES;
    
    UIImageView * currentImage = (UIImageView *) slides[0];
    UIView * lastImage = (UIImageView *) [slides lastObject];
    
    [UIView animateWithDuration:transitionDuration
                     animations:^{
                         currentImage.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self insertSubview:currentImage belowSubview:lastImage];
                         [slides moveObjectFromIndex:0 toIndex:[slides count]];
                         currentImage.alpha = 1;
                         
                         _isAnimating = NO;
                         
                         if(! _doStop){
                             [self performSelector:@selector(next) withObject:nil afterDelay:delay];
                         }
                         
                     }];
    
}


- (void) stop
{
    _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}


@end

